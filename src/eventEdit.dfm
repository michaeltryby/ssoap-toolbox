object frmEventEdit: TfrmEventEdit
  Left = 263
  Top = 241
  BorderStyle = bsSingle
  Caption = 'RDII Event Edit'
  ClientHeight = 297
  ClientWidth = 642
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 7
    Top = 7
    Width = 38
    Height = 13
    Caption = 'Event #'
  end
  object Label1: TLabel
    Left = 7
    Top = 49
    Width = 76
    Height = 13
    Caption = 'Start Date/Time'
  end
  object Label3: TLabel
    Left = 7
    Top = 91
    Width = 73
    Height = 13
    Caption = 'End Date/Time'
  end
  object Label12: TLabel
    Left = 8
    Top = 224
    Width = 47
    Height = 13
    Caption = 'Hit Count:'
    Visible = False
  end
  object Label4: TLabel
    Left = 23
    Top = 166
    Width = 32
    Height = 13
    Caption = 'Label4'
    Visible = False
  end
  object Label5: TLabel
    Left = 23
    Top = 185
    Width = 32
    Height = 13
    Caption = 'Label5'
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 214
    Top = 7
    Width = 419
    Height = 233
    Caption = 'Event Specific RTK Values'
    TabOrder = 7
    inline FrameRTKPattern1: TFrameRTKPattern
      Left = 9
      Top = 22
      Width = 407
      Height = 208
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      TabStop = True
      ExplicitLeft = 9
      ExplicitTop = 22
      ExplicitHeight = 208
      inherited Label3: TLabel
        Width = 68
        Caption = 'Pattern Name:'
        ExplicitWidth = 68
      end
      inherited Label16: TLabel
        Width = 25
        ExplicitWidth = 25
      end
      inherited Label17: TLabel
        Width = 37
        ExplicitWidth = 37
      end
      inherited Label18: TLabel
        Width = 24
        ExplicitWidth = 24
      end
      inherited Label12: TLabel
        Width = 8
        ExplicitWidth = 8
      end
      inherited Label14: TLabel
        Width = 7
        ExplicitWidth = 7
      end
      inherited Label15: TLabel
        Width = 7
        ExplicitWidth = 7
      end
      inherited Label1: TLabel
        Width = 42
        ExplicitWidth = 42
      end
      inherited Label6: TLabel
        Width = 23
        ExplicitWidth = 23
      end
      inherited Label7: TLabel
        Width = 33
        ExplicitWidth = 33
      end
      inherited Label2: TLabel
        Width = 14
        ExplicitWidth = 14
      end
      inherited CheckBox1: TCheckBox
        Left = 294
        Top = -1
        ExplicitLeft = 294
        ExplicitTop = -1
      end
      inherited R3Edit2: TEdit
        OnChange = FrameRTKPattern1R1Edit2Change
      end
      inherited R2Edit2: TEdit
        OnChange = FrameRTKPattern1R1Edit2Change
      end
      inherited R1Edit2: TEdit
        OnChange = FrameRTKPattern1R1Edit2Change
      end
      inherited T3Edit2: TEdit
        OnChange = FrameRTKPattern1T1Edit2Change
      end
      inherited T2Edit2: TEdit
        OnChange = FrameRTKPattern1T1Edit2Change
      end
      inherited T1Edit2: TEdit
        OnChange = FrameRTKPattern1T1Edit2Change
      end
      inherited K3Edit2: TEdit
        OnChange = FrameRTKPattern1K1Edit2Change
      end
      inherited K2Edit2: TEdit
        OnChange = FrameRTKPattern1K1Edit2Change
      end
      inherited K1Edit2: TEdit
        OnChange = FrameRTKPattern1K1Edit2Change
      end
      inherited MemoDescription: TMemo
        OnChange = FrameRTKPattern1MemoDescriptionChange
      end
      inherited EditAI: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAM: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAR: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAI2: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAM2: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAR2: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAI3: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAM3: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
      inherited EditAR3: TEdit
        OnChange = FrameRTKPattern1EditAMChange
      end
    end
  end
  object EventSpinEdit: TSpinEdit
    Left = 7
    Top = 24
    Width = 193
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 0
    Value = 1
    OnChange = EventSpinEditChange
  end
  object StartDatePicker: TDateTimePicker
    Left = 7
    Top = 66
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    OnChange = NonREditChange
  end
  object StartTimePicker: TDateTimePicker
    Left = 110
    Top = 66
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 2
    OnChange = NonREditChange
  end
  object EndDatePicker: TDateTimePicker
    Left = 7
    Top = 108
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 3
    OnChange = NonREditChange
  end
  object EndTimePicker: TDateTimePicker
    Left = 110
    Top = 108
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 4
    OnChange = NonREditChange
  end
  object okButton: TButton
    Left = 135
    Top = 259
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 9
    OnClick = okButtonClick
    OnKeyPress = FormKeyPress
  end
  object helpButton: TButton
    Left = 333
    Top = 259
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 11
    OnClick = helpButtonClick
    OnKeyPress = FormKeyPress
  end
  object cancelButton: TButton
    Left = 433
    Top = 259
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 12
    OnClick = cancelButtonClick
    OnKeyPress = FormKeyPress
  end
  object applyButton: TButton
    Left = 236
    Top = 259
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 10
    OnClick = applyButtonClick
    OnKeyPress = FormKeyPress
  end
  object AutoApplyCheckBox: TCheckBox
    Left = 7
    Top = 143
    Width = 137
    Height = 17
    Caption = 'Auto Apply Changes'
    TabOrder = 5
    OnClick = AutoApplyCheckBoxClick
  end
  object btnDefaults: TButton
    Left = 502
    Top = 142
    Width = 121
    Height = 25
    Caption = 'Load Analysis Defaults'
    TabOrder = 8
    OnClick = btnDefaultsClick
    OnKeyPress = FormKeyPress
  end
  object edPatternName: TEdit
    Left = 296
    Top = 24
    Width = 207
    Height = 21
    TabOrder = 6
    OnChange = NonREditChange
    OnKeyPress = edPatternNameKeyPress
  end
  object Button1: TButton
    Left = 16
    Top = 256
    Width = 25
    Height = 25
    Caption = 'Button1'
    TabOrder = 13
    Visible = False
    OnClick = Button1Click
  end
end
