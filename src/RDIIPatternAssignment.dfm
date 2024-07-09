object frmRDIIPatternAssignment: TfrmRDIIPatternAssignment
  Left = 0
  Top = 0
  Caption = 'RTK Pattern Assignment'
  ClientHeight = 605
  ClientWidth = 712
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
  object GroupBoxRTKParameters: TGroupBox
    Left = 403
    Top = 8
    Width = 282
    Height = 333
    TabOrder = 0
    object Label12: TLabel
      Left = 74
      Top = 65
      Width = 7
      Height = 13
      Caption = 'R'
    end
    object Label14: TLabel
      Left = 144
      Top = 65
      Width = 6
      Height = 13
      Caption = 'T'
    end
    object Label15: TLabel
      Left = 214
      Top = 65
      Width = 6
      Height = 13
      Caption = 'K'
    end
    object Label16: TLabel
      Left = 7
      Top = 85
      Width = 6
      Height = 13
      Caption = '1'
    end
    object Label17: TLabel
      Left = 7
      Top = 110
      Width = 6
      Height = 13
      Caption = '2'
    end
    object Label18: TLabel
      Left = 7
      Top = 137
      Width = 6
      Height = 13
      Caption = '3'
    end
    object Label3: TLabel
      Left = 7
      Top = 50
      Width = 77
      Height = 13
      Caption = 'RTK Parameters'
    end
    object Label4: TLabel
      Left = 7
      Top = 171
      Width = 38
      Height = 13
      Caption = 'Total R:'
    end
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 88
      Height = 13
      Caption = 'RTK Pattern Name'
    end
    object Label2: TLabel
      Left = 8
      Top = 203
      Width = 54
      Height = 13
      Caption = 'Comments:'
    end
    object R1Edit2: TEdit
      Left = 52
      Top = 81
      Width = 49
      Height = 21
      TabOrder = 0
      Text = '0.01'
      OnChange = R1Edit2Change
    end
    object R2Edit2: TEdit
      Left = 52
      Top = 108
      Width = 49
      Height = 21
      TabOrder = 1
      Text = '0.02'
      OnChange = R1Edit2Change
    end
    object R3Edit2: TEdit
      Left = 52
      Top = 135
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '0.03'
      OnChange = R1Edit2Change
    end
    object T1Edit2: TEdit
      Left = 126
      Top = 81
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '1'
    end
    object T2Edit2: TEdit
      Left = 126
      Top = 108
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '2'
    end
    object T3Edit2: TEdit
      Left = 126
      Top = 135
      Width = 49
      Height = 21
      TabOrder = 5
      Text = '3'
    end
    object K1Edit2: TEdit
      Left = 198
      Top = 81
      Width = 49
      Height = 21
      TabOrder = 6
      Text = '1'
    end
    object K2Edit2: TEdit
      Left = 198
      Top = 108
      Width = 49
      Height = 21
      TabOrder = 7
      Text = '2'
    end
    object K3Edit2: TEdit
      Left = 198
      Top = 135
      Width = 49
      Height = 21
      TabOrder = 8
      Text = '3'
    end
    object RTotalEdit: TEdit
      Left = 52
      Top = 168
      Width = 49
      Height = 21
      ReadOnly = True
      TabOrder = 9
      Text = '0.06'
    end
    object MemoComments: TMemo
      Left = 10
      Top = 222
      Width = 257
      Height = 94
      TabOrder = 10
    end
    object ComboBoxRTKPattern: TComboBox
      Left = 7
      Top = 21
      Width = 260
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 11
      OnChange = ComboBoxRTKPatternChange
    end
    object btnEditRTK: TButton
      Left = 176
      Top = 184
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 12
      OnClick = btnEditRTKClick
    end
  end
  object ComboBoxSewershedName: TComboBox
    Left = 8
    Top = 25
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBoxSewershedNameChange
  end
  object ListBoxRDIIAreas: TListBox
    Left = 8
    Top = 71
    Width = 281
    Height = 154
    ItemHeight = 13
    TabOrder = 2
  end
  inline FrameRDIIGraph1: TFrameRDIIGraph
    Left = 8
    Top = 256
    Width = 373
    Height = 341
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    ExplicitLeft = 8
    ExplicitTop = 256
    ExplicitWidth = 373
    ExplicitHeight = 341
  end
  object btnLink: TButton
    Left = 306
    Top = 17
    Width = 75
    Height = 37
    Caption = '<- Assign ->'
    TabOrder = 4
  end
  object GroupBoxAnalysisPicker: TGroupBox
    Left = 403
    Top = 332
    Width = 282
    Height = 265
    TabOrder = 5
    object Label6: TLabel
      Left = 5
      Top = 11
      Width = 43
      Height = 13
      Caption = 'Analyses'
    end
    object Label8: TLabel
      Left = 5
      Top = 57
      Width = 33
      Height = 13
      Caption = 'Events'
    end
    object Label13: TLabel
      Left = 5
      Top = 160
      Width = 86
      Height = 13
      Caption = 'Start Date / Time:'
    end
    object Label19: TLabel
      Left = 5
      Top = 186
      Width = 80
      Height = 13
      Caption = 'End Date / Time:'
    end
    object Label11: TLabel
      Left = 5
      Top = 216
      Width = 60
      Height = 13
      Caption = 'Rain Gauges'
    end
    object ComboBoxAnalysisName: TComboBox
      Left = 5
      Top = 30
      Width = 271
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBoxAnalysisNameChange
    end
    object ListBoxEvents: TListBox
      Left = 5
      Top = 81
      Width = 271
      Height = 69
      ItemHeight = 13
      TabOrder = 1
      OnClick = ListBoxEventsClick
    end
    object StartDatePicker: TDateTimePicker
      Left = 93
      Top = 156
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      TabOrder = 2
    end
    object EndDatePicker: TDateTimePicker
      Left = 93
      Top = 182
      Width = 97
      Height = 21
      Date = 36892.000000000000000000
      Time = 36892.000000000000000000
      DateMode = dmUpDown
      TabOrder = 3
    end
    object StartTimePicker: TDateTimePicker
      Left = 188
      Top = 156
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 4
    end
    object EndTimePicker: TDateTimePicker
      Left = 188
      Top = 183
      Width = 91
      Height = 21
      Date = 2.000000000000000000
      Time = 2.000000000000000000
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 5
    end
    object ComboBoxRainGauges: TComboBox
      Left = 5
      Top = 235
      Width = 271
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 6
    end
  end
end
