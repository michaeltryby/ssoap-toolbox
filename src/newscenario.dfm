object frmAddNewScenario: TfrmAddNewScenario
  Left = 320
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Add New Scenario'
  ClientHeight = 402
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    292
    402)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 73
    Height = 13
    Caption = 'Scenario Name'
  end
  object Label2: TLabel
    Left = 7
    Top = 49
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object ScenarioNameEdit: TEdit
    Left = 6
    Top = 22
    Width = 278
    Height = 21
    TabOrder = 0
  end
  object okButton: TButton
    Left = 8
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 108
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Help'
    TabOrder = 2
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 209
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = cancelButtonClick
  end
  object DescriptionEdit: TEdit
    Left = 8
    Top = 72
    Width = 276
    Height = 21
    TabOrder = 4
  end
  object PanelCopyOptions: TPanel
    Left = 8
    Top = 104
    Width = 276
    Height = 257
    TabOrder = 5
    object Label3: TLabel
      Left = 34
      Top = 34
      Width = 233
      Height = 52
      AutoSize = False
      Caption = 
        'With this option checked, you can edit the RTK patterns for the ' +
        'new scenario without affecting the source scenario.'
      WordWrap = True
    end
    object LabelSuffix: TLabel
      Left = 16
      Top = 80
      Width = 170
      Height = 13
      Caption = 'Suffix to add to RTK Pattern names:'
    end
    object LabelSuffix2: TLabel
      Left = 34
      Top = 97
      Width = 233
      Height = 52
      AutoSize = False
      Caption = 
        'Pattern names must be unique, so a suffix will be added to the c' +
        'opied patterns. Names may be changed later in the RTK Pattern Ma' +
        'nager.'
      WordWrap = True
    end
    object LabelFactor: TLabel
      Left = 34
      Top = 174
      Width = 233
      Height = 39
      AutoSize = False
      Caption = 
        'Handy for creating an I/I Reduction scenario. Enter a factor bet' +
        'ween 0.00 and 1.00 to be applied to each R, e.g. 0.67 for a 33% ' +
        'reduction.'
      WordWrap = True
    end
    object LabelFactor2: TLabel
      Left = 16
      Top = 223
      Width = 33
      Height = 13
      Caption = 'Factor:'
    end
    object CheckBoxMakeCopies: TCheckBox
      Left = 16
      Top = 16
      Width = 249
      Height = 17
      Caption = 'Make copies of the source RTK Patterns'
      TabOrder = 0
      OnClick = CheckBoxMakeCopiesClick
    end
    object EditSuffix: TEdit
      Left = 195
      Top = 77
      Width = 66
      Height = 21
      TabOrder = 1
      Text = '_'
      OnKeyPress = EditSuffixKeyPress
    end
    object CheckBoxFactor: TCheckBox
      Left = 16
      Top = 155
      Width = 249
      Height = 17
      Caption = 'Multiply Rs by a factor'
      TabOrder = 2
      OnClick = CheckBoxFactorClick
    end
    object EditRFactor: TEdit
      Left = 212
      Top = 220
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '1.00'
      OnKeyPress = FloatEditKeyPress
    end
  end
end
