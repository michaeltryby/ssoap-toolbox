object frmImportRDIIAreaDataUsingConverter: TfrmImportRDIIAreaDataUsingConverter
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Import RDII Area Data Using Converter'
  ClientHeight = 261
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 49
    Width = 47
    Height = 13
    Caption = 'File Name'
  end
  object Label2: TLabel
    Left = 8
    Top = 109
    Width = 46
    Height = 13
    Caption = 'Converter'
  end
  object Label3: TLabel
    Left = 7
    Top = 7
    Width = 91
    Height = 13
    Caption = 'Existing RDII Areas'
  end
  object Label4: TLabel
    Left = 8
    Top = 165
    Width = 19
    Height = 13
    Caption = 'Tag'
  end
  object FilenameEdit: TEdit
    Left = 7
    Top = 66
    Width = 337
    Height = 21
    TabOrder = 1
  end
  object browseButton: TButton
    Left = 269
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 2
    OnClick = browseButtonClick
  end
  object ConverterComboBox: TComboBox
    Left = 6
    Top = 126
    Width = 337
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object okButton: TButton
    Left = 39
    Top = 221
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 243
    Top = 221
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = cancelButtonClick
  end
  object helpButton: TButton
    Left = 141
    Top = 221
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 5
    OnClick = helpButtonClick
  end
  object RDIIAreaNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 337
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'OC01'
      'OC02'
      'OC03'
      'OC04'
      'OC05')
  end
  object TagEdit: TEdit
    Left = 8
    Top = 184
    Width = 337
    Height = 21
    TabOrder = 7
  end
  object ButtonViewConverter: TButton
    Left = 268
    Top = 153
    Width = 75
    Height = 25
    Caption = 'View...'
    TabOrder = 8
    OnClick = ButtonViewConverterClick
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.CSV; *.TXT;*.FLO|*.CSV;*.TXT;*.FLO|All Files (*.*)|*.*'
    Left = 208
    Top = 80
  end
end
