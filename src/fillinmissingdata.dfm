object frmFillInMissingDataForm: TfrmFillInMissingDataForm
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Fill In Missing Flow Data'
  ClientHeight = 196
  ClientWidth = 344
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
  object Label3: TLabel
    Left = 7
    Top = 7
    Width = 83
    Height = 13
    Caption = 'Flow Meter Name'
  end
  object Label1: TLabel
    Left = 8
    Top = 118
    Width = 226
    Height = 13
    Caption = 'Largest Gap Which Can Be Interpolated (Hours)'
  end
  object FlowMeterNameComboBox: TComboBox
    Left = 7
    Top = 24
    Width = 329
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object okButton: TButton
    Left = 40
    Top = 164
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 136
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 232
    Top = 164
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 5
    OnClick = cancelButtonClick
  end
  object FillInMethodGroupBox: TGroupBox
    Left = 8
    Top = 49
    Width = 329
    Height = 65
    Caption = 'Fill In Method'
    TabOrder = 1
    object AutomaticRadioButton: TRadioButton
      Left = 7
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Automatic'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object ManualRadioButton: TRadioButton
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      Caption = 'Manual'
      Enabled = False
      TabOrder = 1
    end
  end
  object LargestGapEdit: TEdit
    Left = 7
    Top = 135
    Width = 329
    Height = 21
    TabOrder = 2
    Text = '2'
    OnKeyPress = FloatEdtKeyPress
  end
end
