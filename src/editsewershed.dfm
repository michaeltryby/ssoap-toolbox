object frmEditSewershed: TfrmEditSewershed
  Left = 349
  Top = 162
  BorderStyle = bsDialog
  Caption = 'Edit Sewershed'
  ClientHeight = 372
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
  object Label5: TLabel
    Left = 7
    Top = 51
    Width = 49
    Height = 13
    Caption = 'Area Units'
  end
  object Label2: TLabel
    Left = 8
    Top = 97
    Width = 25
    Height = 13
    Caption = 'Area:'
  end
  object Label3: TLabel
    Left = 8
    Top = 141
    Width = 55
    Height = 13
    Caption = 'Raingauge:'
  end
  object Label4: TLabel
    Left = 8
    Top = 233
    Width = 54
    Height = 13
    Caption = 'Load Point:'
  end
  object Label6: TLabel
    Left = 8
    Top = 277
    Width = 22
    Height = 13
    Caption = 'Tag:'
  end
  object Label7: TLabel
    Left = 8
    Top = 187
    Width = 55
    Height = 13
    Caption = 'Flow Meter:'
  end
  object SewershedNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 277
    Height = 21
    TabOrder = 0
    Text = 'New_Sewershed'
    OnKeyPress = SewershedNameEditKeyPress
  end
  object UnitsComboBox: TComboBox
    Left = 8
    Top = 70
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
  end
  object okButton: TButton
    Left = 14
    Top = 335
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 110
    Top = 335
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 3
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 206
    Top = 335
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = cancelButtonClick
  end
  object EditArea: TEdit
    Left = 8
    Top = 114
    Width = 277
    Height = 21
    TabOrder = 5
    Text = '0.0'
    OnKeyPress = FloatEdtKeyPress
  end
  object ComboBoxRainGauge: TComboBox
    Left = 8
    Top = 160
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 6
  end
  object EditLoadPoint: TEdit
    Left = 7
    Top = 250
    Width = 277
    Height = 21
    TabOrder = 7
  end
  object EditTag: TEdit
    Left = 7
    Top = 294
    Width = 277
    Height = 21
    TabOrder = 8
  end
  object ComboBoxFlowMeter: TComboBox
    Left = 7
    Top = 206
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 9
  end
end
