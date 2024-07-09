object frmEditMeter: TfrmEditMeter
  Left = 349
  Top = 162
  BorderStyle = bsDialog
  Caption = 'Edit Meter'
  ClientHeight = 454
  ClientWidth = 292
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
    Left = 7
    Top = 53
    Width = 117
    Height = 13
    Caption = 'Contributory Area (Acres)'
  end
  object Label3: TLabel
    Left = 8
    Top = 287
    Width = 82
    Height = 13
    Caption = 'Location, Easting'
  end
  object Label4: TLabel
    Left = 8
    Top = 325
    Width = 87
    Height = 13
    Caption = 'Location, Northing'
  end
  object Label5: TLabel
    Left = 7
    Top = 131
    Width = 49
    Height = 13
    Caption = 'Flow Units'
  end
  object Label6: TLabel
    Left = 8
    Top = 249
    Width = 119
    Height = 13
    Caption = 'Flow Time Step (Minutes)'
  end
  object Label7: TLabel
    Left = 8
    Top = 170
    Width = 64
    Height = 13
    Caption = 'Velocity Units'
  end
  object Label8: TLabel
    Left = 8
    Top = 212
    Width = 56
    Height = 13
    Caption = 'Depth Units'
  end
  object Label9: TLabel
    Left = 8
    Top = 92
    Width = 49
    Height = 13
    Caption = 'Area Units'
  end
  object Label10: TLabel
    Left = 8
    Top = 367
    Width = 148
    Height = 13
    Caption = 'Total Sewer Length (linear feet)'
  end
  object MeterNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 277
    Height = 21
    TabOrder = 0
    Text = 'New_Meter'
    OnKeyPress = MeterNameEditKeyPress
  end
  object AreaEdit: TEdit
    Left = 8
    Top = 68
    Width = 277
    Height = 21
    TabOrder = 1
    OnKeyPress = FloatEdtKeyPress
  end
  object EastingEdit: TEdit
    Left = 8
    Top = 302
    Width = 277
    Height = 21
    TabOrder = 7
    Text = '0'
    OnKeyPress = FloatEdtKeyPressAllowNegative
  end
  object NorthingEdit: TEdit
    Left = 8
    Top = 340
    Width = 277
    Height = 21
    TabOrder = 8
    Text = '0'
    OnKeyPress = FloatEdtKeyPressAllowNegative
  end
  object UnitsComboBox: TComboBox
    Left = 8
    Top = 145
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
  end
  object TimeStepSpinEdit: TSpinEdit
    Left = 8
    Top = 263
    Width = 277
    Height = 22
    MaxValue = 60
    MinValue = 1
    TabOrder = 6
    Value = 15
  end
  object okButton: TButton
    Left = 12
    Top = 417
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 9
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 108
    Top = 417
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 10
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 204
    Top = 417
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 11
    OnClick = cancelButtonClick
  end
  object VelocityUnitsComboBox: TComboBox
    Left = 8
    Top = 185
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
  end
  object DepthUnitsComboBox: TComboBox
    Left = 8
    Top = 224
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 5
  end
  object AreaUnitsComboBox: TComboBox
    Left = 8
    Top = 106
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  object EditSewerLength: TEdit
    Left = 8
    Top = 382
    Width = 277
    Height = 21
    TabOrder = 12
    OnKeyPress = FloatEdtKeyPress
  end
end
