object frmAddRdiiDataConverter: TfrmAddRdiiDataConverter
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Add RDII Data Converter'
  ClientHeight = 242
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
    Left = 215
    Top = 35
    Width = 26
    Height = 13
    Caption = 'Node'
  end
  object Label5: TLabel
    Left = 217
    Top = 59
    Width = 22
    Height = 13
    Caption = 'Area'
  end
  object Label6: TLabel
    Left = 203
    Top = 82
    Width = 38
    Height = 13
    Caption = 'Coord X'
  end
  object Label7: TLabel
    Left = 203
    Top = 108
    Width = 38
    Height = 13
    Caption = 'Coord Y'
  end
  object Label8: TLabel
    Left = 222
    Top = 133
    Width = 19
    Height = 13
    Caption = 'Tag'
  end
  object Label9: TLabel
    Left = 215
    Top = 163
    Width = 25
    Height = 13
    Caption = 'Code'
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
    Top = 205
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 17
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 142
    Top = 205
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 18
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 234
    Top = 205
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 19
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
  object NodeColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 28
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 5
    Value = 1
  end
  object NodeWidthSpinEdit: TSpinEdit
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
  object AreaColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 54
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 1
    TabOrder = 7
    Value = 2
  end
  object AreaWidthSpinEdit: TSpinEdit
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
  object NodeLocationXColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 80
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 9
    Value = 0
  end
  object NodeLocationXWidthSpinEdit: TSpinEdit
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
  object NodeLocationYColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 106
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 11
    Value = 0
  end
  object NodeLocationYWidthSpinEdit: TSpinEdit
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
  object TagColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 132
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 13
    Value = 0
  end
  object TagWidthSpinEdit: TSpinEdit
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
  object CodeColumnSpinEdit: TSpinEdit
    Left = 247
    Top = 160
    Width = 40
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 15
    Value = 0
  end
  object CodeWidthSpinEdit: TSpinEdit
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
    TabOrder = 20
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
    Left = 7
    Top = 66
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
  end
end
