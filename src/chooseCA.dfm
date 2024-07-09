object frmCASelector: TfrmCASelector
  Left = 370
  Top = 247
  BorderStyle = bsDialog
  Caption = 
    'Pre- & Post-Sewer Rehabilitation RDII Correlation Analysis Resul' +
    'ts'
  ClientHeight = 107
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 15
    Width = 320
    Height = 13
    Caption = 
      'Available Pre- && Post- Sewer Rehabilitation RDII Correlation An' +
      'alysis'
  end
  object CANameComboBox: TComboBox
    Left = 7
    Top = 32
    Width = 299
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object okButton: TButton
    Left = 40
    Top = 74
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 152
    Top = 74
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    Visible = False
    OnClick = helpButtonClick
  end
  object btnClose: TButton
    Left = 264
    Top = 74
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnDetails: TButton
    Left = 312
    Top = 32
    Width = 57
    Height = 25
    Caption = 'Information'
    TabOrder = 4
    OnClick = btnDetailsClick
  end
end
