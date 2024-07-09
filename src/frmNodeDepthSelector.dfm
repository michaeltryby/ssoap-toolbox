object NodeSelectorForm: TNodeSelectorForm
  Left = 0
  Top = 0
  Caption = 'Junction Depth Selector'
  ClientHeight = 334
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 37
    Width = 45
    Height = 13
    Caption = 'Junctions'
  end
  object Label2: TLabel
    Left = 248
    Top = 37
    Width = 130
    Height = 13
    Caption = 'Depth Timeseries Junctions'
  end
  object Label3: TLabel
    Left = 16
    Top = 8
    Width = 338
    Height = 13
    Caption = 
      'Please Select the Junctions to import full Junction Depth Timese' +
      'ries for'
  end
  object btnOK: TButton
    Left = 72
    Top = 296
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnHelp: TButton
    Left = 176
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 1
    OnClick = btnHelpClick
  end
  object btnCancel: TButton
    Left = 280
    Top = 296
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object ListBoxNodes: TListBox
    Left = 16
    Top = 56
    Width = 161
    Height = 217
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
  end
  object ListBoxSelectedNodes: TListBox
    Left = 248
    Top = 56
    Width = 161
    Height = 217
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
  end
  object btnAdd: TButton
    Left = 192
    Top = 80
    Width = 41
    Height = 25
    Caption = 'Add ->'
    TabOrder = 5
    OnClick = btnAddClick
  end
  object btnRemove: TButton
    Left = 192
    Top = 128
    Width = 41
    Height = 25
    Caption = '<- Rem'
    TabOrder = 6
    OnClick = btnRemoveClick
  end
end
