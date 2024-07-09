object frmAddEditHoliday: TfrmAddEditHoliday
  Left = 0
  Top = 0
  Anchors = [akLeft, akRight, akBottom]
  Caption = 'Add / Edit Holiday'
  ClientHeight = 286
  ClientWidth = 287
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    287
    286)
  PixelsPerInch = 96
  TextHeight = 13
  object okButton: TButton
    Left = 14
    Top = 251
    Width = 72
    Height = 25
    Anchors = [akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 110
    Top = 251
    Width = 72
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    TabOrder = 1
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 206
    Top = 251
    Width = 72
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = cancelButtonClick
  end
  object PanelExisting: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    DesignSize = (
      273
      105)
    object lblExistingName: TLabel
      Left = 8
      Top = 8
      Width = 71
      Height = 13
      Caption = 'Existing Name:'
    end
    object lblExistingDate: TLabel
      Left = 8
      Top = 54
      Width = 67
      Height = 13
      Caption = 'Existing Date:'
    end
    object EditExistingName: TEdit
      Left = 8
      Top = 27
      Width = 257
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnKeyPress = EditNewNameKeyPress
    end
    object DateTimePickerExisting: TDateTimePicker
      Left = 8
      Top = 73
      Width = 186
      Height = 21
      Date = 39380.625124687500000000
      Time = 39380.625124687500000000
      TabOrder = 1
    end
  end
  object PanelNew: TPanel
    Left = 8
    Top = 119
    Width = 273
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    DesignSize = (
      273
      105)
    object lblNewName: TLabel
      Left = 8
      Top = 8
      Width = 55
      Height = 13
      Caption = 'New Name:'
    end
    object lblNewDate: TLabel
      Left = 8
      Top = 54
      Width = 51
      Height = 13
      Caption = 'New Date:'
    end
    object EditNewName: TEdit
      Left = 8
      Top = 27
      Width = 257
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnKeyPress = EditNewNameKeyPress
    end
    object DateTimePickerNew: TDateTimePicker
      Left = 8
      Top = 73
      Width = 186
      Height = 21
      Date = 39380.625368113430000000
      Time = 39380.625368113430000000
      TabOrder = 1
    end
  end
end
