object frmFlowUnitManagement: TfrmFlowUnitManagement
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Flow Unit Management'
  ClientHeight = 215
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 7
    Width = 49
    Height = 13
    Caption = 'Flow Units'
  end
  object addButton: TButton
    Left = 18
    Top = 187
    Width = 75
    Height = 25
    Caption = 'Add...'
    TabOrder = 2
  end
  object closeButton: TButton
    Left = 194
    Top = 187
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 4
    OnClick = closeButtonClick
  end
  object helpButton: TButton
    Left = 102
    Top = 187
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 3
    Visible = False
    OnClick = helpButtonClick
  end
  object editButton: TButton
    Left = 64
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Edit...'
    TabOrder = 0
  end
  object deleteButton: TButton
    Left = 156
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Delete...'
    TabOrder = 1
  end
end
