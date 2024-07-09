object frmRTKPatternAssignment: TfrmRTKPatternAssignment
  Left = 0
  Top = 0
  Caption = 'Scenario RTK Pattern Assignment'
  ClientHeight = 431
  ClientWidth = 791
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    791
    431)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 42
    Width = 58
    Height = 13
    Caption = 'Sewersheds'
  end
  object LabelRDIIAreas: TLabel
    Left = 178
    Top = 42
    Width = 53
    Height = 13
    Caption = 'RDII Areas'
    Visible = False
  end
  object Label3: TLabel
    Left = 328
    Top = 53
    Width = 63
    Height = 13
    Caption = 'RTK Patterns'
  end
  object lblSelectedSewerShed: TLabel
    Left = 16
    Top = 199
    Width = 144
    Height = 13
    AutoSize = False
    Caption = '-'
    Color = clWindow
    ParentColor = False
    Visible = False
  end
  object lblSelectedRDIIArea: TLabel
    Left = 172
    Top = 199
    Width = 144
    Height = 13
    AutoSize = False
    Caption = '-'
    Color = clWindow
    ParentColor = False
    Visible = False
  end
  object lblSelectedPattern: TLabel
    Left = 328
    Top = 199
    Width = 358
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '-'
    Color = clWindow
    ParentColor = False
    Visible = False
  end
  object Label4: TLabel
    Left = 16
    Top = 221
    Width = 171
    Height = 13
    Caption = 'RTK Pattern Links for This Scenario:'
  end
  object lblScenarioID: TLabel
    Left = 16
    Top = 8
    Width = 55
    Height = 13
    Caption = 'Scenario ID'
  end
  object lblDescription: TLabel
    Left = 16
    Top = 23
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object lblSelectedPatternLongName: TLabel
    Left = 312
    Top = 213
    Width = 4
    Height = 13
    Caption = '-'
    Visible = False
  end
  object Label5: TLabel
    Left = 16
    Top = 61
    Width = 29
    Height = 13
    Caption = 'BOLD'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 15
    Top = 73
    Width = 101
    Height = 13
    Caption = 'items are unassigned'
  end
  object Label7: TLabel
    Left = 328
    Top = 69
    Width = 266
    Height = 13
    Caption = 'RTK Pattern Name: R1, T1, K1; R2, T2, K2; R3, T3, K3;'
  end
  object Shape1: TShape
    Left = 16
    Top = 38
    Width = 758
    Height = 2
  end
  object LabelExplanation: TLabel
    Left = 192
    Top = 104
    Width = 99
    Height = 78
    Caption = 
      'Select a sewershed from the left and an RTK pattern from the rig' +
      'ht and then press the "Add Link" button below.'
    WordWrap = True
  end
  object ListBoxRDIIAreas: TListBox
    Left = 172
    Top = 88
    Width = 148
    Height = 101
    Style = lbOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 4
    Visible = False
    OnClick = ListBoxRDIIAreasClick
    OnDrawItem = ListBoxSewerShedsDrawItem
  end
  object okButton: TButton
    Left = 16
    Top = 394
    Width = 75
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 117
    Top = 395
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Help'
    TabOrder = 1
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 216
    Top = 395
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Close'
    TabOrder = 2
    OnClick = cancelButtonClick
  end
  object ListBoxSewerSheds: TListBox
    Left = 16
    Top = 88
    Width = 148
    Height = 101
    Style = lbOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 3
    OnClick = ListBoxSewerShedsClick
    OnDrawItem = ListBoxSewerShedsDrawItem
  end
  object btnAddLink: TButton
    Left = 212
    Top = 195
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Add Link'
    TabOrder = 5
    OnClick = btnAddLinkClick
  end
  object btnDeleteLink: TButton
    Left = 701
    Top = 261
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete Link'
    TabOrder = 6
    OnClick = btnDeleteLinkClick
  end
  object btnModifyLink: TButton
    Left = 701
    Top = 292
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Modify Link'
    TabOrder = 7
    Visible = False
  end
  object StringGridRTKLink: TStringGrid
    Left = 16
    Top = 240
    Width = 670
    Height = 146
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    DefaultColWidth = 24
    DefaultRowHeight = 19
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect]
    TabOrder = 8
    OnClick = StringGridRTKLinkClick
    ColWidths = (
      24
      94
      467)
  end
  object btnEditSewerShed: TButton
    Left = 79
    Top = 46
    Width = 66
    Height = 25
    Caption = 'Edit'
    TabOrder = 9
    OnClick = btnEditSewerShedClick
  end
  object btnEditRDIIArea: TButton
    Left = 237
    Top = 46
    Width = 66
    Height = 25
    Caption = 'Edit'
    TabOrder = 10
    Visible = False
    OnClick = btnEditRDIIAreaClick
  end
  object btnEditRTKPattern: TButton
    Left = 708
    Top = 48
    Width = 66
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Edit'
    TabOrder = 11
    OnClick = btnEditRTKPatternClick
  end
  object CheckBoxSelectAllRDIIAreas: TCheckBox
    Left = 173
    Top = 56
    Width = 63
    Height = 17
    Caption = 'Select All'
    TabOrder = 12
    Visible = False
    OnClick = CheckBoxSelectAllRDIIAreasClick
  end
  object CheckBoxFromAnalyses: TCheckBox
    Left = 410
    Top = 52
    Width = 239
    Height = 17
    Caption = 'From Analyses Associated with Sewershed'
    TabOrder = 13
    OnClick = CheckBoxFromAnalysesClick
  end
  object CheckBoxIgnoreRDIIAreas: TCheckBox
    Left = 173
    Top = 72
    Width = 120
    Height = 17
    Caption = 'Ignore RDII Areas'
    TabOrder = 14
    Visible = False
    OnClick = CheckBoxIgnoreRDIIAreasClick
  end
  object CheckBox1: TCheckBox
    Left = 616
    Top = 8
    Width = 158
    Height = 17
    Caption = 'Show RDII Area (advanced)'
    TabOrder = 15
    OnClick = CheckBox1Click
  end
  object StringGridRTKPatterns: TStringGrid
    Left = 326
    Top = 88
    Width = 448
    Height = 103
    Anchors = [akLeft, akTop, akRight]
    ColCount = 10
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 16
    OnClick = StringGridRTKPatternsClick
    ColWidths = (
      133
      40
      26
      26
      39
      26
      25
      43
      26
      26)
  end
end
