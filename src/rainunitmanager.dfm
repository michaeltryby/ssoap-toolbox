object frmRainUnitManagement: TfrmRainUnitManagement
  Left = 320
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Rain Unit Management'
  ClientHeight = 215
  ClientWidth = 280
  Color = clBtnFace
  Constraints.MaxWidth = 288
  Constraints.MinHeight = 180
  Constraints.MinWidth = 286
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    280
    215)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 7
    Width = 49
    Height = 13
    Caption = 'Rain Units'
  end
  object addButton: TButton
    Left = 34
    Top = 187
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Add...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object closeButton: TButton
    Left = 186
    Top = 187
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 4
    OnClick = closeButtonClick
  end
  object helpButton: TButton
    Left = 110
    Top = 187
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Help'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = helpButtonClick
  end
  object editButton: TButton
    Left = 72
    Top = 151
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Edit...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object deleteButton: TButton
    Left = 148
    Top = 151
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Delete...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
