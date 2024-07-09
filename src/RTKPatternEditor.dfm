object frmRTKPatternEditor: TfrmRTKPatternEditor
  Left = 0
  Top = 0
  Caption = 'RTK Pattern Editor'
  ClientHeight = 657
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label11: TLabel
    Left = 8
    Top = 51
    Width = 55
    Height = 13
    Caption = 'Rain Gauge'
  end
  object Label13: TLabel
    Left = 8
    Top = 106
    Width = 86
    Height = 13
    Caption = 'Start Date / Time:'
  end
  object Label19: TLabel
    Left = 8
    Top = 129
    Width = 84
    Height = 13
    Caption = 'Stop Date / Time:'
  end
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object ComboBoxRainGauges: TComboBox
    Left = 8
    Top = 70
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBoxRainGaugesChange
  end
  object GroupBoxRTKParameters: TGroupBox
    Left = 8
    Top = 152
    Width = 282
    Height = 465
    TabOrder = 6
    object Label6: TLabel
      Left = 14
      Top = 323
      Width = 27
      Height = 13
      Caption = 'Area:'
    end
    object LabelAreaUnits: TLabel
      Left = 132
      Top = 323
      Width = 11
      Height = 13
      Caption = 'ac'
    end
    object Label8: TLabel
      Left = 14
      Top = 350
      Width = 51
      Height = 13
      Caption = 'Rain Peak:'
    end
    object LabelVolUnits: TLabel
      Left = 160
      Top = 374
      Width = 8
      Height = 13
      Caption = 'in'
    end
    object Label9: TLabel
      Left = 14
      Top = 376
      Width = 60
      Height = 13
      Caption = 'Total Depth:'
    end
    object LabelMaxUnits: TLabel
      Left = 160
      Top = 350
      Width = 8
      Height = 13
      Caption = 'in'
    end
    object Label16: TLabel
      Left = 17
      Top = 175
      Width = 26
      Height = 13
      Caption = 'Short'
    end
    object Label17: TLabel
      Left = 17
      Top = 200
      Width = 36
      Height = 13
      Caption = 'Medium'
    end
    object Label18: TLabel
      Left = 17
      Top = 227
      Width = 23
      Height = 13
      Caption = 'Long'
    end
    inline FrameRTKPattern1: TFrameRTKPattern
      Left = 14
      Top = 0
      Width = 256
      Height = 318
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      TabStop = True
      OnMouseLeave = FrameRTKPattern1MouseLeave
      ExplicitLeft = 14
      ExplicitWidth = 256
      ExplicitHeight = 318
      inherited lblDescription: TLabel
        Top = 255
        ExplicitTop = 255
      end
      inherited Label5: TLabel
        Left = 59
        Top = 156
        ExplicitLeft = 59
        ExplicitTop = 156
      end
      inherited Label6: TLabel
        Left = 121
        Top = 156
        ExplicitLeft = 121
        ExplicitTop = 156
      end
      inherited Label7: TLabel
        Enabled = False
      end
      inherited Label2: TLabel
        Left = 182
        Top = 156
        ExplicitLeft = 182
        ExplicitTop = 156
      end
      inherited CheckBox1: TCheckBox
        Left = 5
        Top = 141
        ExplicitLeft = 5
        ExplicitTop = 141
      end
      inherited MemoDescription: TMemo
        Top = 274
        Width = 244
        ExplicitTop = 274
        ExplicitWidth = 244
      end
      inherited EditAI: TEdit
        Left = 168
        Top = 172
        ExplicitLeft = 168
        ExplicitTop = 172
      end
      inherited EditAM: TEdit
        Left = 48
        Top = 172
        ExplicitLeft = 48
        ExplicitTop = 172
      end
      inherited EditAR: TEdit
        Left = 108
        Top = 172
        ExplicitLeft = 108
        ExplicitTop = 172
      end
      inherited EditAI2: TEdit
        Left = 168
        Top = 199
        ExplicitLeft = 168
        ExplicitTop = 199
      end
      inherited EditAM2: TEdit
        Left = 48
        Top = 199
        ExplicitLeft = 48
        ExplicitTop = 199
      end
      inherited EditAR2: TEdit
        Left = 108
        Top = 199
        ExplicitLeft = 108
        ExplicitTop = 199
      end
      inherited EditAI3: TEdit
        Left = 168
        Top = 226
        ExplicitLeft = 168
        ExplicitTop = 226
      end
      inherited EditAM3: TEdit
        Left = 48
        Top = 226
        ExplicitLeft = 48
        ExplicitTop = 226
      end
      inherited EditAR3: TEdit
        Left = 108
        Top = 226
        ExplicitLeft = 108
        ExplicitTop = 226
      end
    end
    object EditArea: TEdit
      Left = 59
      Top = 320
      Width = 65
      Height = 21
      TabOrder = 1
      Text = '100.0'
    end
    object EditPeak: TEdit
      Left = 89
      Top = 347
      Width = 65
      Height = 21
      Color = clSilver
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object EditVolume: TEdit
      Left = 89
      Top = 373
      Width = 65
      Height = 21
      Color = clSilver
      ReadOnly = True
      TabOrder = 3
      Text = '0'
    end
    object btnSaveRTKs: TButton
      Left = 187
      Top = 416
      Width = 83
      Height = 27
      Caption = 'Save Pattern'
      Enabled = False
      TabOrder = 5
      OnClick = btnSaveRTKsClick
    end
    object btnUpdate: TButton
      Left = 106
      Top = 416
      Width = 75
      Height = 27
      Caption = 'Update Chart'
      TabOrder = 4
      OnClick = btnUpdateClick
    end
  end
  object StartDatePicker: TDateTimePicker
    Left = 95
    Top = 98
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 2
  end
  object EndDatePicker: TDateTimePicker
    Left = 96
    Top = 125
    Width = 97
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    DateMode = dmUpDown
    TabOrder = 4
  end
  object StartTimePicker: TDateTimePicker
    Left = 198
    Top = 98
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 3
  end
  object EndTimePicker: TDateTimePicker
    Left = 199
    Top = 125
    Width = 91
    Height = 21
    Date = 2.000000000000000000
    Time = 2.000000000000000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 5
  end
  inline FrameRDIIGraph1: TFrameRDIIGraph
    Left = 296
    Top = 4
    Width = 363
    Height = 644
    TabOrder = 9
    TabStop = True
    ExplicitLeft = 296
    ExplicitTop = 4
    ExplicitWidth = 363
    ExplicitHeight = 644
  end
  object helpButton: TButton
    Left = 67
    Top = 623
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 7
    OnClick = helpButtonClick
  end
  object closeButton: TButton
    Left = 162
    Top = 623
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 8
    OnClick = closeButtonClick
  end
  object RTKPatternNameEdit: TEdit
    Left = 7
    Top = 24
    Width = 282
    Height = 21
    TabOrder = 0
    Text = 'New RTK Pattern'
    OnChange = RTKPatternNameEditChange
    OnKeyPress = RTKPatternNameEditKeyPress
  end
end
