object frmAddRDIIAreaDataConverter: TfrmAddRDIIAreaDataConverter
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Add RDII Area Data Converter'
  ClientHeight = 249
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
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
    Left = 7
    Top = 49
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
    Left = 213
    Top = 32
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label5: TLabel
    Left = 192
    Top = 83
    Width = 49
    Height = 13
    Caption = 'Area Units'
    Visible = False
  end
  object Label6: TLabel
    Left = 219
    Top = 111
    Width = 22
    Height = 13
    Caption = 'Area'
  end
  object Label8: TLabel
    Left = 190
    Top = 137
    Width = 51
    Height = 13
    Caption = 'Load Point'
  end
  object Label9: TLabel
    Left = 222
    Top = 165
    Width = 19
    Height = 13
    Caption = 'Tag'
  end
  object Label7: TLabel
    Left = 188
    Top = 55
    Width = 53
    Height = 13
    Caption = 'Sewershed'
  end
  object Label12: TLabel
    Left = 213
    Top = 68
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object NewNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 169
    Height = 21
    TabOrder = 0
  end
  object okButton: TButton
    Left = 49
    Top = 209
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 15
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 142
    Top = 209
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 16
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 234
    Top = 209
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 17
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
  object SpinEditNameColumn: TSpinEdit
    Left = 247
    Top = 28
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 5
    Value = 1
  end
  object SpinEditNameWidth: TSpinEdit
    Left = 299
    Top = 28
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 6
    Value = 10
  end
  object SpinEditAreaUnitsColumn: TSpinEdit
    Left = 247
    Top = 80
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 7
    Value = 0
    Visible = False
  end
  object SpinEditAreaUnitsWidth: TSpinEdit
    Left = 299
    Top = 80
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 8
    Value = 10
    Visible = False
  end
  object SpinEditAreaColumn: TSpinEdit
    Left = 247
    Top = 106
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 9
    Value = 3
  end
  object SpinEditAreaWidth: TSpinEdit
    Left = 299
    Top = 106
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 10
    Value = 10
  end
  object SpinEditLoadPointColumn: TSpinEdit
    Left = 247
    Top = 134
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 11
    Value = 0
  end
  object SpinEditLoadPointWidth: TSpinEdit
    Left = 299
    Top = 134
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 12
    Value = 10
  end
  object SpinEditTagColumn: TSpinEdit
    Left = 247
    Top = 162
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 13
    Value = 0
  end
  object SpinEditTagWidth: TSpinEdit
    Left = 299
    Top = 160
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 14
    Value = 10
  end
  object RadioGroup1: TRadioGroup
    Left = 7
    Top = 133
    Width = 169
    Height = 59
    Caption = 'Format'
    TabOrder = 18
  end
  object ColumnWidthRadioButton: TRadioButton
    Left = 18
    Top = 168
    Width = 92
    Height = 13
    Caption = 'Column / Width'
    TabOrder = 4
    OnClick = ColumnWidthRadioButtonClick
  end
  object CSVRadioButton: TRadioButton
    Left = 18
    Top = 148
    Width = 92
    Height = 14
    Caption = 'CSV'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = CSVRadioButtonClick
  end
  object UnitsComboBox: TComboBox
    Left = 6
    Top = 64
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
  end
  object SpinEditSewerShedNameColumn: TSpinEdit
    Left = 247
    Top = 58
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 19
    Value = 2
  end
  object SpinEditSewerShedNameWidth: TSpinEdit
    Left = 299
    Top = 58
    Width = 40
    Height = 22
    Enabled = False
    MaxValue = 20
    MinValue = 0
    TabOrder = 20
    Value = 10
  end
end
