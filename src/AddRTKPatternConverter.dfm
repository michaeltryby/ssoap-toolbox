object frmAddRTKPatternConverter: TfrmAddRTKPatternConverter
  Left = 0
  Top = 0
  Caption = 'frmAddRTKPatternConverter'
  ClientHeight = 545
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 79
    Height = 13
    Caption = 'Converter Name'
  end
  object Label3: TLabel
    Left = 7
    Top = 91
    Width = 59
    Height = 13
    Caption = 'Lines to Skip'
  end
  object Label10: TLabel
    Left = 247
    Top = 7
    Width = 38
    Height = 13
    Caption = 'Column '
  end
  object Label11: TLabel
    Left = 299
    Top = 7
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object Label4: TLabel
    Left = 176
    Top = 31
    Width = 66
    Height = 13
    Caption = 'Pattern Name'
  end
  object Label7: TLabel
    Left = 190
    Top = 59
    Width = 50
    Height = 13
    Caption = 'Comments'
  end
  object Label5: TLabel
    Left = 228
    Top = 84
    Width = 13
    Height = 13
    Caption = 'R1'
  end
  object Label6: TLabel
    Left = 229
    Top = 111
    Width = 12
    Height = 13
    Caption = 'T1'
  end
  object Label8: TLabel
    Left = 229
    Top = 138
    Width = 12
    Height = 13
    Caption = 'K1'
  end
  object Label2: TLabel
    Left = 228
    Top = 165
    Width = 13
    Height = 13
    Caption = 'R2'
  end
  object Label9: TLabel
    Left = 229
    Top = 192
    Width = 12
    Height = 13
    Caption = 'T2'
  end
  object Label12: TLabel
    Left = 229
    Top = 219
    Width = 12
    Height = 13
    Caption = 'K2'
  end
  object Label13: TLabel
    Left = 229
    Top = 246
    Width = 13
    Height = 13
    Caption = 'R3'
  end
  object Label14: TLabel
    Left = 230
    Top = 273
    Width = 12
    Height = 13
    Caption = 'T3'
  end
  object Label15: TLabel
    Left = 230
    Top = 300
    Width = 12
    Height = 13
    Caption = 'K3'
  end
  object NewNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 163
    Height = 21
    TabOrder = 0
  end
  object LinesToSkipSpinEdit: TSpinEdit
    Left = 7
    Top = 108
    Width = 163
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object RadioGroup1: TRadioGroup
    Left = 7
    Top = 133
    Width = 163
    Height = 59
    Caption = 'Format'
    TabOrder = 2
  end
  object SpinEditK1Column: TSpinEdit
    Left = 247
    Top = 134
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 3
    Value = 5
  end
  object SpinEditK1Width: TSpinEdit
    Left = 299
    Top = 134
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 4
    Value = 8
  end
  object SpinEditT1Column: TSpinEdit
    Left = 247
    Top = 106
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 5
    Value = 4
  end
  object SpinEditT1Width: TSpinEdit
    Left = 299
    Top = 106
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 6
    Value = 8
  end
  object SpinEditR1Column: TSpinEdit
    Left = 247
    Top = 80
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 7
    Value = 3
  end
  object SpinEditR1Width: TSpinEdit
    Left = 299
    Top = 80
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 8
    Value = 8
  end
  object SpinEditCommentsColumn: TSpinEdit
    Left = 247
    Top = 54
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 9
    Value = 2
  end
  object SpinEditCommentsWidth: TSpinEdit
    Left = 299
    Top = 54
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 200
    MinValue = 0
    TabOrder = 10
    Value = 32
  end
  object SpinEditNameColumn: TSpinEdit
    Left = 247
    Top = 28
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 11
    Value = 1
  end
  object SpinEditNameWidth: TSpinEdit
    Left = 299
    Top = 28
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 50
    MinValue = 0
    TabOrder = 12
    Value = 20
  end
  object okButton: TButton
    Left = 38
    Top = 510
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 13
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 131
    Top = 512
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 14
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 223
    Top = 510
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 15
    OnClick = cancelButtonClick
  end
  object CSVRadioButton: TRadioButton
    Left = 18
    Top = 148
    Width = 92
    Height = 14
    Caption = 'CSV'
    Checked = True
    TabOrder = 16
    TabStop = True
    OnClick = CSVRadioButtonClick
  end
  object ColumnWidthRadioButton: TRadioButton
    Left = 18
    Top = 168
    Width = 92
    Height = 13
    Caption = 'Column / Width'
    TabOrder = 17
    OnClick = CSVRadioButtonClick
  end
  object SpinEditR2Column: TSpinEdit
    Left = 247
    Top = 161
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 18
    Value = 6
  end
  object SpinEditT2Column: TSpinEdit
    Left = 247
    Top = 187
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 19
    Value = 7
  end
  object SpinEditK2Column: TSpinEdit
    Left = 247
    Top = 215
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 20
    Value = 8
  end
  object SpinEditR2Width: TSpinEdit
    Left = 299
    Top = 161
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 21
    Value = 8
  end
  object SpinEditT2Width: TSpinEdit
    Left = 299
    Top = 187
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 22
    Value = 8
  end
  object SpinEditK2Width: TSpinEdit
    Left = 299
    Top = 215
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 23
    Value = 8
  end
  object SpinEditR3Column: TSpinEdit
    Left = 248
    Top = 242
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 24
    Value = 9
  end
  object SpinEditT3Column: TSpinEdit
    Left = 248
    Top = 268
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 25
    Value = 10
  end
  object SpinEditK3Column: TSpinEdit
    Left = 248
    Top = 296
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 26
    Value = 11
  end
  object SpinEditR3Width: TSpinEdit
    Left = 300
    Top = 242
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 27
    Value = 8
  end
  object SpinEditT3Width: TSpinEdit
    Left = 300
    Top = 268
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 28
    Value = 8
  end
  object SpinEditK3Width: TSpinEdit
    Left = 300
    Top = 296
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 29
    Value = 8
  end
  object gbAdvanced: TGroupBox
    Left = 8
    Top = 198
    Width = 162
    Height = 299
    Caption = 'Advanced'
    TabOrder = 30
    object Label16: TLabel
      Left = 30
      Top = 89
      Width = 19
      Height = 13
      Caption = 'Do1'
    end
    object Label17: TLabel
      Left = 55
      Top = 20
      Width = 38
      Height = 13
      Caption = 'Column '
    end
    object Label18: TLabel
      Left = 107
      Top = 20
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object Label19: TLabel
      Left = 16
      Top = 42
      Width = 33
      Height = 13
      Caption = 'Dmax1'
    end
    object Label20: TLabel
      Left = 21
      Top = 66
      Width = 28
      Height = 13
      Caption = 'Drec1'
    end
    object Label21: TLabel
      Left = 19
      Top = 269
      Width = 30
      Height = 13
      Caption = 'Month'
    end
    object Label22: TLabel
      Left = 16
      Top = 115
      Width = 33
      Height = 13
      Caption = 'Dmax2'
    end
    object Label23: TLabel
      Left = 21
      Top = 139
      Width = 28
      Height = 13
      Caption = 'Drec2'
    end
    object Label24: TLabel
      Left = 30
      Top = 163
      Width = 19
      Height = 13
      Caption = 'Do2'
    end
    object Label25: TLabel
      Left = 16
      Top = 188
      Width = 33
      Height = 13
      Caption = 'Dmax3'
    end
    object Label26: TLabel
      Left = 21
      Top = 212
      Width = 28
      Height = 13
      Caption = 'Drec3'
    end
    object Label27: TLabel
      Left = 30
      Top = 236
      Width = 19
      Height = 13
      Caption = 'Do3'
    end
    object SpinEditAMColumn: TSpinEdit
      Left = 55
      Top = 39
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object SpinEditAMWidth: TSpinEdit
      Left = 107
      Top = 39
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 1
      Value = 8
    end
    object SpinEditARColumn: TSpinEdit
      Left = 55
      Top = 63
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object SpinEditARWidth: TSpinEdit
      Left = 107
      Top = 63
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 3
      Value = 8
    end
    object SpinEditAIColumn: TSpinEdit
      Left = 55
      Top = 87
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object SpinEditAIWidth: TSpinEdit
      Left = 107
      Top = 87
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 5
      Value = 8
    end
    object SpinEditMonColumn: TSpinEdit
      Left = 55
      Top = 266
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 18
      Value = 0
    end
    object SpinEditMonWidth: TSpinEdit
      Left = 107
      Top = 266
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 19
      Value = 8
    end
    object SpinEditAM2Column: TSpinEdit
      Left = 55
      Top = 112
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 6
      Value = 0
    end
    object SpinEditAR2Column: TSpinEdit
      Left = 55
      Top = 136
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 8
      Value = 0
    end
    object SpinEditAI2Column: TSpinEdit
      Left = 55
      Top = 160
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 10
      Value = 0
    end
    object SpinEditAM2Width: TSpinEdit
      Left = 107
      Top = 112
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 7
      Value = 8
    end
    object SpinEditAR2Width: TSpinEdit
      Left = 107
      Top = 136
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 9
      Value = 8
    end
    object SpinEditAI2Width: TSpinEdit
      Left = 107
      Top = 160
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 11
      Value = 8
    end
    object SpinEditAM3Column: TSpinEdit
      Left = 55
      Top = 185
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 12
      Value = 0
    end
    object SpinEditAM3Width: TSpinEdit
      Left = 107
      Top = 185
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 13
      Value = 8
    end
    object SpinEditAR3Column: TSpinEdit
      Left = 55
      Top = 209
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 14
      Value = 0
    end
    object SpinEditAR3Width: TSpinEdit
      Left = 107
      Top = 209
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 15
      Value = 8
    end
    object SpinEditAI3Column: TSpinEdit
      Left = 55
      Top = 233
      Width = 40
      Height = 22
      MaxValue = 200
      MinValue = 0
      TabOrder = 16
      Value = 0
    end
    object SpinEditAI3Width: TSpinEdit
      Left = 107
      Top = 233
      Width = 40
      Height = 22
      Enabled = False
      MaxValue = 20
      MinValue = 0
      TabOrder = 17
      Value = 8
    end
  end
end
