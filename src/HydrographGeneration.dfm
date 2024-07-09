object frmHydrographGeneration: TfrmHydrographGeneration
  Left = 0
  Top = 0
  Caption = 'RDII Hydrograph Generation'
  ClientHeight = 628
  ClientWidth = 874
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
  object Label7: TLabel
    Left = 8
    Top = 8
    Width = 83
    Height = 13
    Caption = 'Sewershed Name'
  end
  object Label1: TLabel
    Left = 8
    Top = 131
    Width = 69
    Height = 13
    Caption = 'Analysis Name'
  end
  object Label5: TLabel
    Left = 8
    Top = 44
    Width = 83
    Height = 13
    Caption = 'RDII Area Names'
  end
  object okButton: TButton
    Left = 8
    Top = 597
    Width = 75
    Height = 25
    Caption = 'Export'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 105
    Top = 597
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    Visible = False
    OnClick = helpButtonClick
  end
  object cancelButton: TButton
    Left = 203
    Top = 597
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cancelButtonClick
  end
  object SewershedNameComboBox: TComboBox
    Left = 8
    Top = 25
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = SewershedNameComboBoxChange
  end
  object AnalysisNameComboBox: TComboBox
    Left = 8
    Top = 150
    Width = 282
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object EventGroupBox1: TGroupBox
    Left = 8
    Top = 245
    Width = 281
    Height = 219
    TabOrder = 5
    object Label2: TLabel
      Left = 11
      Top = 13
      Width = 28
      Height = 13
      Caption = 'Event'
    end
    object Label4: TLabel
      Left = 56
      Top = 88
      Width = 7
      Height = 13
      Caption = 'R'
    end
    object EventsMemo: TMemo
      Left = 11
      Top = 60
      Width = 257
      Height = 145
      Lines.Strings = (
        'EventsMemo')
      TabOrder = 0
    end
  end
  object StatBasedHydrographGroupBox1: TGroupBox
    Left = 8
    Top = 464
    Width = 282
    Height = 127
    Enabled = False
    TabOrder = 6
    object Label12: TLabel
      Left = 56
      Top = 25
      Width = 7
      Height = 13
      Caption = 'R'
    end
    object Label14: TLabel
      Left = 126
      Top = 25
      Width = 6
      Height = 13
      Caption = 'T'
    end
    object Label15: TLabel
      Left = 196
      Top = 25
      Width = 6
      Height = 13
      Caption = 'K'
    end
    object Label16: TLabel
      Left = 13
      Top = 45
      Width = 6
      Height = 13
      Caption = '1'
    end
    object Label17: TLabel
      Left = 13
      Top = 70
      Width = 6
      Height = 13
      Caption = '2'
    end
    object Label18: TLabel
      Left = 13
      Top = 97
      Width = 6
      Height = 13
      Caption = '3'
    end
    object Label3: TLabel
      Left = 13
      Top = 6
      Width = 142
      Height = 13
      Caption = 'User Defined RTK Parameters'
    end
    object R1Edit2: TEdit
      Left = 34
      Top = 41
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = '0.01'
    end
    object R2Edit2: TEdit
      Left = 34
      Top = 68
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0.02'
    end
    object R3Edit2: TEdit
      Left = 34
      Top = 95
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = '0.03'
    end
    object T1Edit2: TEdit
      Left = 108
      Top = 41
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 3
      Text = '1'
    end
    object T2Edit2: TEdit
      Left = 108
      Top = 68
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 4
      Text = '2'
    end
    object T3Edit2: TEdit
      Left = 108
      Top = 95
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 5
      Text = '3'
    end
    object K1Edit2: TEdit
      Left = 180
      Top = 41
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 6
      Text = '1'
    end
    object K2Edit2: TEdit
      Left = 180
      Top = 68
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 7
      Text = '2'
    end
    object K3Edit2: TEdit
      Left = 180
      Top = 95
      Width = 49
      Height = 21
      Enabled = False
      TabOrder = 8
      Text = '3'
    end
    object Button1: TButton
      Left = 235
      Top = 88
      Width = 44
      Height = 25
      Caption = 'Update'
      TabOrder = 9
      OnClick = Button1Click
    end
  end
  object EventSpinEdit: TSpinEdit
    Left = 19
    Top = 277
    Width = 121
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 7
    Value = 1
    OnChange = EventSpinEditChange
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 177
    Width = 281
    Height = 71
    Caption = 'RDII Parameters'
    TabOrder = 8
  end
  object RadioEventBased1: TRadioButton
    Left = 21
    Top = 200
    Width = 201
    Height = 17
    Caption = 'Event Based RTK Parameters'
    Checked = True
    TabOrder = 10
    TabStop = True
    OnClick = RadioEventBased1Click
  end
  object RadioUserBased1: TRadioButton
    Left = 21
    Top = 223
    Width = 177
    Height = 17
    Caption = 'User Defined RTK Parameters'
    TabOrder = 9
    OnClick = RadioUserBased1Click
  end
  object ListBoxRDIIAreas: TListBox
    Left = 8
    Top = 63
    Width = 281
    Height = 69
    ItemHeight = 13
    TabOrder = 11
    OnClick = ListBoxRDIIAreasClick
  end
  object SaveStatsDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 376
    Top = 544
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 376
    Top = 512
  end
end
