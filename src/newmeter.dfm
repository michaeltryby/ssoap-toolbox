object frmAddNewMeter: TfrmAddNewMeter
  Left = 320
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Add New Meter'
  ClientHeight = 469
  ClientWidth = 291
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
    Top = 49
    Width = 117
    Height = 13
    Caption = 'Contributory Area (Acres)'
  end
  object Label3: TLabel
    Left = 6
    Top = 303
    Width = 82
    Height = 13
    Caption = 'Location, Easting'
  end
  object Label4: TLabel
    Left = 6
    Top = 343
    Width = 87
    Height = 13
    Caption = 'Location, Northing'
  end
  object Label5: TLabel
    Left = 8
    Top = 131
    Width = 49
    Height = 13
    Caption = 'Flow Units'
  end
  object Label6: TLabel
    Left = 6
    Top = 261
    Width = 120
    Height = 13
    Caption = 'Data Time Step (Minutes)'
  end
  object Label7: TLabel
    Left = 8
    Top = 173
    Width = 64
    Height = 13
    Caption = 'Velocity Units'
  end
  object Label8: TLabel
    Left = 8
    Top = 217
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
    Top = 387
    Width = 160
    Height = 13
    Caption = 'Total Length of Sewer (linear feet)'
  end
  object MeterNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 277
    Height = 21
    TabOrder = 0
    OnKeyPress = MeterNameEditKeyPress
  end
  object AreaEdit: TEdit
    Left = 7
    Top = 66
    Width = 277
    Height = 21
    TabOrder = 1
    Text = '100'
    OnKeyPress = FloatEditKeyPress
  end
  object EastingEdit: TEdit
    Left = 6
    Top = 320
    Width = 277
    Height = 21
    TabOrder = 4
    Text = '0'
    OnKeyPress = FloatEditKeyPressAllowNegative
  end
  object NorthingEdit: TEdit
    Left = 6
    Top = 360
    Width = 277
    Height = 21
    TabOrder = 5
    Text = '0'
    OnKeyPress = FloatEditKeyPressAllowNegative
  end
  object FlowUnitsComboBox: TComboBox
    Left = 6
    Top = 148
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  object TimeStepSpinEdit: TSpinEdit
    Left = 6
    Top = 278
    Width = 277
    Height = 22
    MaxValue = 60
    MinValue = 1
    TabOrder = 3
    Value = 15
  end
  object okButton: TButton
    Left = 11
    Top = 436
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 6
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 107
    Top = 436
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 7
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 203
    Top = 436
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = cancelButtonClick
  end
  object VelocityUnitsComboBox: TComboBox
    Left = 6
    Top = 190
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 9
  end
  object DepthUnitsComboBox: TComboBox
    Left = 6
    Top = 234
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 10
  end
  object AreaUnitsComboBox: TComboBox
    Left = 8
    Top = 106
    Width = 275
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 11
  end
  object EditSewerLength: TEdit
    Left = 7
    Top = 404
    Width = 277
    Height = 21
    TabOrder = 12
    Text = '10000'
    OnKeyPress = FloatEditKeyPress
  end
end
