object frmEditCatchment: TfrmEditCatchment
  Left = 349
  Top = 162
  BorderStyle = bsDialog
  Caption = 'Edit RDII Area'
  ClientHeight = 369
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
  DesignSize = (
    292
    369)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 7
    Width = 78
    Height = 13
    Caption = 'RDII Area Name'
  end
  object Label5: TLabel
    Left = 8
    Top = 103
    Width = 49
    Height = 13
    Caption = 'Area Units'
  end
  object Label2: TLabel
    Left = 8
    Top = 149
    Width = 25
    Height = 13
    Caption = 'Area:'
  end
  object Label3: TLabel
    Left = 8
    Top = 57
    Width = 56
    Height = 13
    Caption = 'Sewershed:'
  end
  object Label4: TLabel
    Left = 8
    Top = 235
    Width = 54
    Height = 13
    Caption = 'Load Point:'
  end
  object Label6: TLabel
    Left = 8
    Top = 281
    Width = 22
    Height = 13
    Caption = 'Tag:'
  end
  object Label7: TLabel
    Left = 15
    Top = 210
    Width = 162
    Height = 13
    Caption = 'Sum of RDII Areas for Sewershed:'
  end
  object Label8: TLabel
    Left = 62
    Top = 195
    Width = 115
    Height = 13
    Caption = 'Parent Sewershed Area:'
  end
  object lblSewerShedArea: TLabel
    Left = 182
    Top = 195
    Width = 99
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = '0.00'
  end
  object lblSumRDIIAreas: TLabel
    Left = 182
    Top = 210
    Width = 99
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = '0.00'
  end
  object RDIIAreaNameEdit: TEdit
    Left = 8
    Top = 24
    Width = 277
    Height = 21
    TabOrder = 0
    Text = 'New_Catchment'
    OnKeyPress = RDIIAreaNameEditKeyPress
  end
  object UnitsComboBox: TComboBox
    Left = 8
    Top = 122
    Width = 277
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 0
    Sorted = True
    TabOrder = 1
  end
  object okButton: TButton
    Left = 10
    Top = 331
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 110
    Top = 331
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 3
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 206
    Top = 331
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = cancelButtonClick
  end
  object EditArea: TEdit
    Left = 8
    Top = 168
    Width = 277
    Height = 21
    TabOrder = 5
    Text = '0.0'
    OnChange = EditAreaChange
    OnKeyPress = FloatEdtKeyPress
  end
  object ComboBoxSewerShed: TComboBox
    Left = 8
    Top = 76
    Width = 277
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    Sorted = True
    TabOrder = 6
    OnChange = ComboBoxSewerShedChange
  end
  object EditLoadPoint: TEdit
    Left = 8
    Top = 254
    Width = 277
    Height = 21
    TabOrder = 7
  end
  object EditTag: TEdit
    Left = 8
    Top = 300
    Width = 277
    Height = 21
    TabOrder = 8
  end
  object btnEditSewerShed: TButton
    Left = 209
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 9
    OnClick = btnEditSewerShedClick
  end
end
