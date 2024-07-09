object frmMenuItem: TfrmMenuItem
  Left = 0
  Top = 0
  Caption = 'Menu Item Selector'
  ClientHeight = 374
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    430
    374)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 395
    Height = 13
    Caption = 
      'Please Select the Menu Item that you with to report on from the ' +
      'Main Menu above'
  end
  object Label2: TLabel
    Left = 8
    Top = 151
    Width = 112
    Height = 13
    Caption = 'Enter comments below:'
  end
  object Memo1: TMemo
    Left = 8
    Top = 35
    Width = 409
    Height = 110
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 0
    WordWrap = False
    OnKeyPress = Memo1KeyPress
  end
  object Memo2: TMemo
    Left = 8
    Top = 170
    Width = 409
    Height = 151
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 136
    Top = 341
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 224
    Top = 341
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object Button1: TButton
    Left = 342
    Top = 341
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Whole'
    TabOrder = 4
    OnClick = Button1Click
  end
  object MainMenu1: TMainMenu
    Left = 336
    Top = 72
  end
end
