object frmAddNewGauge: TfrmAddNewGauge
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Add New Raingauge'
  ClientHeight = 254
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
  object Label3: TLabel
    Left = 7
    Top = 133
    Width = 82
    Height = 13
    Caption = 'Location, Easting'
  end
  object Label4: TLabel
    Left = 7
    Top = 175
    Width = 87
    Height = 13
    Caption = 'Location, Northing'
  end
  object Label5: TLabel
    Left = 7
    Top = 49
    Width = 49
    Height = 13
    Caption = 'Rain Units'
  end
  object Label6: TLabel
    Left = 7
    Top = 91
    Width = 119
    Height = 13
    Caption = 'Rain Time Step (Minutes)'
  end
  object GaugeNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 277
    Height = 21
    TabOrder = 0
    OnKeyPress = GaugeNameEditKeyPress
  end
  object EastingEdit: TEdit
    Left = 7
    Top = 150
    Width = 277
    Height = 21
    TabOrder = 3
    Text = '0'
    OnKeyPress = FloatEditKeyPressAllowNegative
  end
  object NorthingEdit: TEdit
    Left = 7
    Top = 192
    Width = 277
    Height = 21
    TabOrder = 4
    Text = '0'
    OnKeyPress = FloatEditKeyPressAllowNegative
  end
  object UnitsComboBox: TComboBox
    Left = 7
    Top = 66
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object TimeStepSpinEdit: TSpinEdit
    Left = 7
    Top = 108
    Width = 277
    Height = 22
    MaxValue = 60
    MinValue = 1
    TabOrder = 2
    Value = 15
  end
  object okButton: TButton
    Left = 8
    Top = 221
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 104
    Top = 221
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 6
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 200
    Top = 221
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = cancelButtonClick
  end
end
