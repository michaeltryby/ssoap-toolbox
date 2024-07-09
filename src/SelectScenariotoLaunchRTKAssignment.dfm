object frmSelScenario4RTKAssignment: TfrmSelScenario4RTKAssignment
  Left = 0
  Top = 0
  Caption = 'Select or Create Scenario'
  ClientHeight = 349
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    282
    349)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 189
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object ListBoxLabel: TLabel
    Left = 8
    Top = 53
    Width = 41
    Height = 13
    Caption = 'Scenario'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 264
    Height = 39
    AutoSize = False
    Caption = 
      'RTK Pattern Assignment is organized by Scenario. Please select a' +
      ' Scenario or create a new one and then press the "Select" button' +
      ' to proceed.'
    WordWrap = True
  end
  object btnSelect: TButton
    Left = 8
    Top = 316
    Width = 75
    Height = 25
    Anchors = []
    Caption = 'Select'
    TabOrder = 0
    OnClick = btnSelectClick
  end
  object ScenarioDesciption: TMemo
    Left = 8
    Top = 208
    Width = 265
    Height = 67
    TabOrder = 1
  end
  object ScenarioListBox: TListBox
    Left = 7
    Top = 72
    Width = 265
    Height = 111
    ItemHeight = 13
    TabOrder = 2
    OnClick = ScenarioListBoxClick
  end
  object btnAddNew: TButton
    Left = 45
    Top = 281
    Width = 75
    Height = 25
    Anchors = []
    BiDiMode = bdLeftToRight
    Caption = 'Add New...'
    ParentBiDiMode = False
    TabOrder = 3
    OnClick = btnAddNewClick
  end
  object closeButton: TButton
    Left = 197
    Top = 316
    Width = 75
    Height = 25
    Anchors = []
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 4
    OnClick = closeButtonClick
  end
  object helpButton: TButton
    Left = 101
    Top = 316
    Width = 75
    Height = 25
    Anchors = []
    Caption = 'Help'
    TabOrder = 5
    OnClick = helpButtonClick
  end
  object btnCopy: TButton
    Left = 149
    Top = 281
    Width = 75
    Height = 25
    Anchors = []
    BiDiMode = bdLeftToRight
    Caption = 'Copy...'
    ParentBiDiMode = False
    TabOrder = 6
    OnClick = btnCopyClick
  end
end
