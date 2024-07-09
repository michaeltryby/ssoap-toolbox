object frmCAAnalysesSelector: TfrmCAAnalysesSelector
  Left = 370
  Top = 247
  BorderStyle = bsDialog
  Caption = 'Sewer Rehabilitation Effectiveness Analysis Setup'
  ClientHeight = 408
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 91
    Width = 196
    Height = 13
    Caption = 'RDII Analysis for Rehabiliated Sewershed'
  end
  object Label2: TLabel
    Left = 8
    Top = 137
    Width = 184
    Height = 13
    Caption = 'RDII Analysis for Controlled Sewershed'
  end
  object Label3: TLabel
    Left = 8
    Top = 219
    Width = 196
    Height = 13
    Caption = 'RDII Analysis for Rehabiliated Sewershed'
  end
  object Label4: TLabel
    Left = 7
    Top = 265
    Width = 182
    Height = 13
    Caption = 'RDII Analysis for Controled Sewershed'
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 290
    Height = 13
    Caption = 'Pre- && Post- Rehab RDII Correlation Analysis Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 8
    Top = 330
    Width = 157
    Height = 13
    Caption = 'Event Overlap Tolerance (hours):'
  end
  object Label7: TLabel
    Left = 8
    Top = 64
    Width = 169
    Height = 13
    Caption = 'Pre-Rehabilitation Conditions:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 200
    Width = 175
    Height = 13
    Caption = 'Post-Rehabilitation Conditions:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object AnalysisNameComboBox1: TComboBox
    Left = 95
    Top = 110
    Width = 218
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object okButton: TButton
    Left = 40
    Top = 371
    Width = 75
    Height = 25
    Caption = 'SAVE'
    Default = True
    TabOrder = 1
    OnClick = okButtonClick
  end
  object helpButton: TButton
    Left = 152
    Top = 371
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    Visible = False
    OnClick = helpButtonClick
  end
  object btnClose: TButton
    Left = 264
    Top = 371
    Width = 75
    Height = 25
    Caption = 'Cancel'
    Default = True
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object AnalysisNameComboBox2: TComboBox
    Left = 96
    Top = 156
    Width = 217
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object AnalysisNameComboBox3: TComboBox
    Left = 96
    Top = 238
    Width = 217
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object AnalysisNameComboBox4: TComboBox
    Left = 95
    Top = 284
    Width = 218
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object Edit1: TEdit
    Left = 95
    Top = 27
    Width = 265
    Height = 21
    TabOrder = 7
  end
  object btnDetails1: TButton
    Left = 320
    Top = 108
    Width = 49
    Height = 25
    Caption = 'Info'
    TabOrder = 8
    OnClick = btnDetails1Click
  end
  object btnDetails2: TButton
    Left = 319
    Top = 154
    Width = 49
    Height = 25
    Caption = 'Info'
    TabOrder = 9
    OnClick = btnDetails1Click
  end
  object btnDetails3: TButton
    Left = 319
    Top = 236
    Width = 49
    Height = 25
    Caption = 'Info'
    TabOrder = 10
    OnClick = btnDetails1Click
  end
  object btnDetails4: TButton
    Left = 319
    Top = 282
    Width = 49
    Height = 25
    Caption = 'Info'
    TabOrder = 11
    OnClick = btnDetails1Click
  end
  object UpDown1: TUpDown
    Left = 296
    Top = 331
    Width = 17
    Height = 25
    TabOrder = 12
    OnClick = UpDown1Click
  end
  object EditOlapTol: TEdit
    Left = 264
    Top = 332
    Width = 31
    Height = 21
    TabOrder = 13
    Text = '6'
    OnKeyPress = EditOlapTolKeyPress
  end
  object ButtonAnalyze: TButton
    Left = 319
    Top = 330
    Width = 49
    Height = 25
    Caption = 'Analyze'
    TabOrder = 14
    Visible = False
    OnClick = ButtonAnalyzeClick
  end
end
