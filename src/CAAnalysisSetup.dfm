object frmCAAnalysisSetup: TfrmCAAnalysisSetup
  Left = 0
  Top = 0
  Caption = 'Sewershed Priorization Analysis - Management'
  ClientHeight = 342
  ClientWidth = 1011
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  DesignSize = (
    1011
    342)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 241
    Height = 16
    AutoSize = False
    Caption = 'Available RDII Analysis Results'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 301
    Top = 8
    Width = 244
    Height = 17
    AutoSize = False
    Caption = 'Step 1: Select sub-sewersheds '
    WordWrap = True
  end
  object Label5: TLabel
    Left = 568
    Top = 8
    Width = 276
    Height = 52
    Caption = 'Step 2: Select a RDII parameters for prioritization'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 855
    Top = 9
    Width = 241
    Height = 15
    AutoSize = False
    Caption = 'Available Analyzes in Database'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 301
    Top = 314
    Width = 244
    Height = 26
    AutoSize = False
    Visible = False
    WordWrap = True
  end
  object RadioGroup1: TRadioGroup
    Left = 568
    Top = 30
    Width = 279
    Height = 215
    Caption = 'RDII Parameters Options (Pick 1)'
    TabOrder = 9
  end
  object okButton: TButton
    Left = 730
    Top = 265
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 0
    OnClick = okButtonClick
    ExplicitTop = 314
  end
  object helpButton: TButton
    Left = 649
    Top = 265
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Help'
    Enabled = False
    TabOrder = 1
    ExplicitTop = 314
  end
  object btnClose: TButton
    Left = 936
    Top = 265
    Width = 67
    Height = 44
    Anchors = [akLeft, akBottom]
    Caption = 'Close'
    Default = True
    TabOrder = 2
    OnClick = btnCloseClick
    ExplicitTop = 314
  end
  object ListBoxAvailable: TListBox
    Left = 8
    Top = 30
    Width = 241
    Height = 278
    ItemHeight = 13
    TabOrder = 3
  end
  object ListBoxSelected: TListBox
    Left = 301
    Top = 30
    Width = 244
    Height = 278
    ItemHeight = 13
    TabOrder = 4
  end
  object btnAdd: TButton
    Left = 255
    Top = 57
    Width = 40
    Height = 25
    Hint = 'Add'
    Caption = '-->'
    TabOrder = 5
    OnClick = btnAddClick
  end
  object btnRemove: TButton
    Left = 255
    Top = 88
    Width = 40
    Height = 25
    Hint = 'Remove'
    Caption = 'X'
    TabOrder = 6
    OnClick = btnRemoveClick
  end
  object btnAddAll: TButton
    Left = 255
    Top = 137
    Width = 40
    Height = 25
    Hint = 'Add All'
    Caption = '-->>>'
    TabOrder = 7
    OnClick = btnAddAllClick
  end
  object btnRemoveAll: TButton
    Left = 255
    Top = 168
    Width = 40
    Height = 25
    Hint = 'Remove All'
    Caption = 'XXX'
    TabOrder = 8
    OnClick = btnRemoveAllClick
  end
  object RadioButton1: TRadioButton
    Left = 584
    Top = 43
    Width = 113
    Height = 17
    Caption = 'Total R'
    TabOrder = 10
  end
  object RadioButton2: TRadioButton
    Left = 584
    Top = 66
    Width = 201
    Height = 17
    Caption = 'Total R (with R1, R2 & R3 distribution)'
    TabOrder = 11
  end
  object RadioButton3: TRadioButton
    Left = 584
    Top = 89
    Width = 201
    Height = 17
    Caption = 'R1 (fast response)'
    TabOrder = 12
  end
  object RadioButton4: TRadioButton
    Left = 584
    Top = 112
    Width = 201
    Height = 17
    Caption = 'R2 (medium response)'
    TabOrder = 13
  end
  object RadioButton5: TRadioButton
    Left = 584
    Top = 135
    Width = 201
    Height = 17
    Caption = 'R3 (slow response)'
    TabOrder = 14
  end
  object RadioButton6: TRadioButton
    Left = 584
    Top = 158
    Width = 256
    Height = 17
    Caption = 'R2 + R3 (medium and slow response)'
    TabOrder = 15
  end
  object RadioButton7: TRadioButton
    Left = 584
    Top = 181
    Width = 169
    Height = 15
    Caption = 'RDII volume per sewer length '
    TabOrder = 16
  end
  object RadioButton8: TRadioButton
    Left = 584
    Top = 202
    Width = 225
    Height = 15
    Caption = 'Peak RDII flow rate per drainage area unit'
    TabOrder = 17
  end
  object AddScenarioButton: TButton
    AlignWithMargins = True
    Left = 855
    Top = 264
    Width = 75
    Height = 44
    Anchors = [akLeft, akBottom]
    Caption = 'Step 3: Add New Analysis'
    TabOrder = 18
    WordWrap = True
    OnClick = AddScenarioButtonClick
  end
  object RadioGroupStatOptions: TRadioGroup
    Left = 568
    Top = 252
    Width = 281
    Height = 56
    Caption = 'Statistics Options (Pick 1)'
    Columns = 3
    Items.Strings = (
      'Average'
      'Peak'
      'Median')
    TabOrder = 19
  end
  object ListBoxScenarios: TListBox
    Left = 855
    Top = 30
    Width = 138
    Height = 228
    ItemHeight = 13
    TabOrder = 20
    OnClick = ListBoxScenariosClick
  end
  object btnQuickView: TButton
    Left = 568
    Top = 314
    Width = 75
    Height = 25
    Caption = '<-Quick View'
    TabOrder = 21
    Visible = False
    OnClick = btnQuickViewClick
  end
  object RadioButton9: TRadioButton
    Left = 584
    Top = 223
    Width = 225
    Height = 15
    Caption = 'Peak RDII Flow / ADWF ratio'
    TabOrder = 22
  end
end
