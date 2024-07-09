object frmEditFlowMeterDataConverter: TfrmEditFlowMeterDataConverter
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Edit Flow Meter Data Converter'
  ClientHeight = 318
  ClientWidth = 346
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
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 8
    Top = 47
    Width = 24
    Height = 13
    Caption = 'Units'
  end
  object Label3: TLabel
    Left = 7
    Top = 91
    Width = 61
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
    Left = 208
    Top = 33
    Width = 30
    Height = 13
    Caption = 'Month'
  end
  object Label5: TLabel
    Left = 217
    Top = 59
    Width = 19
    Height = 13
    Caption = 'Day'
  end
  object Label6: TLabel
    Left = 214
    Top = 85
    Width = 22
    Height = 13
    Caption = 'Year'
  end
  object Label7: TLabel
    Left = 214
    Top = 111
    Width = 23
    Height = 13
    Caption = 'Hour'
  end
  object Label8: TLabel
    Left = 206
    Top = 137
    Width = 32
    Height = 13
    Caption = 'Minute'
  end
  object Label9: TLabel
    Left = 215
    Top = 163
    Width = 22
    Height = 13
    Caption = 'Flow'
  end
  object Label12: TLabel
    Left = 103
    Top = -1
    Width = 25
    Height = 13
    Caption = 'Code'
    Visible = False
  end
  object Label13: TLabel
    Left = 203
    Top = 188
    Width = 37
    Height = 13
    Caption = 'Velocity'
  end
  object Label14: TLabel
    Left = 211
    Top = 217
    Width = 29
    Height = 13
    Caption = 'Depth'
  end
  object Label15: TLabel
    Left = 214
    Top = 258
    Width = 75
    Height = 13
    Caption = 'AM/PM Column'
  end
  object NameEdit: TEdit
    Left = 7
    Top = 24
    Width = 169
    Height = 21
    TabOrder = 0
    Text = 'New Converter'
  end
  object okButton: TButton
    Left = 41
    Top = 277
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 19
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 134
    Top = 277
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 20
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 226
    Top = 277
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 21
    OnClick = cancelButtonClick
  end
  object LinesToSkipSpinEdit: TSpinEdit
    Left = 7
    Top = 108
    Width = 169
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object MonthColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 28
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 5
    Value = 1
  end
  object MonthWidthSpinEdit: TSpinEdit
    Left = 299
    Top = 28
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 6
    Value = 2
  end
  object DayColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 54
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 7
    Value = 2
  end
  object DayWidthSpinEdit: TSpinEdit
    Left = 299
    Top = 54
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 8
    Value = 2
  end
  object YearColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 80
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 9
    Value = 3
  end
  object YearWidthSpinEdit: TSpinEdit
    Left = 299
    Top = 80
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 10
    Value = 4
  end
  object HourColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 106
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 11
    Value = 4
  end
  object HourWidthSpinEdit: TSpinEdit
    Left = 299
    Top = 106
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 12
    Value = 2
  end
  object MinuteColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 132
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 13
    Value = 5
  end
  object MinuteWidthSpinEdit: TSpinEdit
    Left = 299
    Top = 132
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 14
    Value = 2
  end
  object FlowColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 158
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 15
    Value = 6
  end
  object FlowWidthSpinEdit: TSpinEdit
    Left = 299
    Top = 158
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 16
    Value = 8
  end
  object RadioGroup1: TRadioGroup
    Left = 7
    Top = 133
    Width = 169
    Height = 59
    Caption = 'Format'
    TabOrder = 22
  end
  object ColumnWidthRadioButton: TRadioButton
    Left = 13
    Top = 153
    Width = 92
    Height = 13
    Caption = 'Column / Width'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = ColumnWidthRadioButtonClick
  end
  object CSVRadioButton: TRadioButton
    Left = 13
    Top = 172
    Width = 92
    Height = 14
    Caption = 'CSV'
    TabOrder = 4
    OnClick = CSVRadioButtonClick
  end
  object CodeColumnSpinEdit: TSpinEdit
    Left = 134
    Top = -4
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 17
    Value = 0
    Visible = False
  end
  object CodeWidthSpinEdit: TSpinEdit
    Left = 186
    Top = -4
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 18
    Value = 0
    Visible = False
  end
  object UnitsComboBox: TComboBox
    Left = 7
    Top = 66
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    Sorted = True
    TabOrder = 1
  end
  object VelocityColumnSpinEdit: TSpinEdit
    Left = 246
    Top = 186
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 23
    Value = 7
  end
  object VelocityWidthSpinEdit: TSpinEdit
    Left = 299
    Top = 186
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 24
    Value = 8
  end
  object DepthColumnSpinEdit: TSpinEdit
    Left = 246
    Top = 214
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 25
    Value = 8
  end
  object DepthWidthSpinEdit: TSpinEdit
    Left = 298
    Top = 214
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 26
    Value = 8
  end
  object RadioGroup2: TRadioGroup
    Left = 8
    Top = 198
    Width = 169
    Height = 56
    Caption = 'Data'
    TabOrder = 27
  end
  object VelocityCheckBox: TCheckBox
    Left = 19
    Top = 216
    Width = 97
    Height = 17
    Caption = 'Velocity'
    Checked = True
    State = cbChecked
    TabOrder = 28
    OnClick = VelocityCheckBoxClick
  end
  object DepthCheckBox: TCheckBox
    Left = 18
    Top = 231
    Width = 97
    Height = 17
    Caption = 'Depth'
    Checked = True
    State = cbChecked
    TabOrder = 29
    OnClick = DepthCheckBoxClick
  end
  object MilitaryTimeCheckBox: TCheckBox
    Left = 18
    Top = 258
    Width = 78
    Height = 13
    Caption = 'Military Time'
    Checked = True
    State = cbChecked
    TabOrder = 30
    OnClick = MilitaryTimeCheckBoxClick
  end
  object AMPMSpinEdit: TSpinEdit
    Left = 298
    Top = 253
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 200
    MinValue = 0
    TabOrder = 31
    Value = 9
  end
end
