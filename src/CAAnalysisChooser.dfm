object frmCAAnalysisChooser: TfrmCAAnalysisChooser
  Left = 0
  Top = 0
  Caption = 'RDII Comparison'
  ClientHeight = 602
  ClientWidth = 893
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
    893
    602)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 241
    Height = 26
    Caption = 'Step1: Review RDII Analysis Results Available for Sub-Sewersheds'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 301
    Top = 9
    Width = 207
    Height = 26
    Caption = 'Step 2: Select sub-sewersheds to create a comparison scenario'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 8
    Top = 359
    Width = 244
    Height = 13
    Caption = 'Step 4: Review Available Scenarios for Comparison'
  end
  object Label4: TLabel
    Left = 304
    Top = 359
    Width = 226
    Height = 13
    Caption = 'Step 5: Select up to 3 scenarios for comparison'
  end
  object Label5: TLabel
    Left = 568
    Top = 8
    Width = 212
    Height = 26
    Caption = 
      'Step 3: Select comparison options and save settings to a compari' +
      'son scenario'
    WordWrap = True
  end
  object RadioGroup1: TRadioGroup
    Left = 568
    Top = 44
    Width = 279
    Height = 201
    Caption = 'Comparison Options'
    TabOrder = 9
  end
  object okButton: TButton
    Left = 140
    Top = 501
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Compare!'
    Default = True
    TabOrder = 0
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 244
    Top = 501
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Help'
    TabOrder = 1
    Visible = False
  end
  object btnClose: TButton
    Left = 356
    Top = 501
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Close'
    Default = True
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object ListBoxAvailable: TListBox
    Left = 8
    Top = 49
    Width = 241
    Height = 288
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 3
  end
  object ListBoxSelected: TListBox
    Left = 301
    Top = 49
    Width = 244
    Height = 288
    Anchors = [akLeft, akTop, akBottom]
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
    Top = 65
    Width = 113
    Height = 17
    Caption = 'Total R (Observed)'
    TabOrder = 10
  end
  object RadioButton2: TRadioButton
    Left = 584
    Top = 88
    Width = 201
    Height = 17
    Caption = 'Total R (Estimated, R1 + R2 + R3)'
    TabOrder = 11
  end
  object RadioButton3: TRadioButton
    Left = 584
    Top = 111
    Width = 201
    Height = 17
    Caption = 'R1 (Estimated, fast response)'
    TabOrder = 12
  end
  object RadioButton4: TRadioButton
    Left = 584
    Top = 134
    Width = 201
    Height = 17
    Caption = 'R2 (Estimated, medium response)'
    TabOrder = 13
  end
  object RadioButton5: TRadioButton
    Left = 584
    Top = 157
    Width = 201
    Height = 17
    Caption = 'R3 (Estimated, slow response)'
    TabOrder = 14
  end
  object RadioButton6: TRadioButton
    Left = 584
    Top = 180
    Width = 256
    Height = 17
    Caption = 'R2 + R3 (Estimated, medium and slow response)'
    TabOrder = 15
  end
  object RadioButton7: TRadioButton
    Left = 584
    Top = 203
    Width = 169
    Height = 15
    Caption = 'RDII volume per sewer length '
    TabOrder = 16
  end
  object RadioButton8: TRadioButton
    Left = 584
    Top = 224
    Width = 225
    Height = 15
    Caption = 'Peak RDII flow rate per drainage area unit'
    TabOrder = 17
  end
  object ComparisonScenarioListBox: TListBox
    Left = 8
    Top = 378
    Width = 241
    Height = 110
    ItemHeight = 13
    TabOrder = 18
    OnClick = ComparisonScenarioListBoxClick
  end
  object AddScenarioButton: TButton
    Left = 568
    Top = 315
    Width = 81
    Height = 25
    Caption = 'Save Scenario'
    TabOrder = 19
    OnClick = AddScenarioButtonClick
  end
  object RadioGroup2: TRadioGroup
    Left = 568
    Top = 252
    Width = 281
    Height = 57
    Caption = 'Statistics Options'
    TabOrder = 20
  end
  object CheckBox_OptionAvg: TCheckBox
    Left = 584
    Top = 275
    Width = 73
    Height = 17
    Caption = 'Average'
    TabOrder = 21
    OnClick = CheckBox_OptionAvgClick
  end
  object CheckBox_OptionPeak: TCheckBox
    Left = 672
    Top = 275
    Width = 57
    Height = 17
    Caption = 'Peak'
    TabOrder = 22
    OnClick = CheckBox_OptionPeakClick
  end
  object CheckBox_OptionMed: TCheckBox
    Left = 752
    Top = 275
    Width = 65
    Height = 17
    Caption = 'Median'
    TabOrder = 23
    OnClick = CheckBox_OptionMedClick
  end
  object ScenarioToDisplayListBox: TListBox
    Left = 304
    Top = 378
    Width = 241
    Height = 110
    ItemHeight = 13
    TabOrder = 24
    OnClick = ComparisonScenarioListBoxClick
  end
  object SelectScenarioForDisplay: TButton
    Left = 257
    Top = 392
    Width = 41
    Height = 25
    Caption = ' --->'
    TabOrder = 25
    OnClick = SelectScenarioForDisplayClick
  end
  object RemoveScenarioFromDisplay: TButton
    Left = 256
    Top = 432
    Width = 41
    Height = 25
    Caption = ' X'
    TabOrder = 26
    OnClick = RemoveScenarioFromDisplayClick
  end
end
