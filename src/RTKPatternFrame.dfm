object FrameRTKPattern: TFrameRTKPattern
  Left = 0
  Top = 0
  Width = 407
  Height = 211
  Ctl3D = True
  ParentCtl3D = False
  TabOrder = 0
  TabStop = True
  object Label3: TLabel
    Left = 3
    Top = 0
    Width = 77
    Height = 13
    Caption = 'RTK Parameters'
  end
  object Label16: TLabel
    Left = 3
    Top = 35
    Width = 26
    Height = 13
    Caption = 'Short'
  end
  object Label17: TLabel
    Left = 3
    Top = 60
    Width = 36
    Height = 13
    Caption = 'Medium'
  end
  object Label18: TLabel
    Left = 3
    Top = 87
    Width = 23
    Height = 13
    Caption = 'Long'
  end
  object Label4: TLabel
    Left = 3
    Top = 117
    Width = 38
    Height = 13
    Caption = 'Total R:'
  end
  object Label12: TLabel
    Left = 70
    Top = 15
    Width = 7
    Height = 13
    Caption = 'R'
  end
  object Label14: TLabel
    Left = 126
    Top = 15
    Width = 6
    Height = 13
    Caption = 'T'
  end
  object Label15: TLabel
    Left = 188
    Top = 15
    Width = 6
    Height = 13
    Caption = 'K'
  end
  object lblDescription: TLabel
    Left = 3
    Top = 141
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label1: TLabel
    Left = 507
    Top = 15
    Width = 45
    Height = 13
    Caption = 'Abstrctn:'
    Visible = False
  end
  object Label5: TLabel
    Left = 242
    Top = 15
    Width = 27
    Height = 13
    Caption = 'Dmax'
    Visible = False
  end
  object Label6: TLabel
    Left = 304
    Top = 15
    Width = 22
    Height = 13
    Caption = 'Drec'
    Visible = False
  end
  object Label7: TLabel
    Left = 143
    Top = 117
    Width = 34
    Height = 13
    Caption = 'Month:'
    Visible = False
  end
  object Label2: TLabel
    Left = 365
    Top = 15
    Width = 13
    Height = 13
    Caption = 'Do'
    Visible = False
  end
  object CheckBox1: TCheckBox
    Left = 231
    Top = 0
    Width = 110
    Height = 17
    Caption = 'Initial lAbstraction'
    TabOrder = 21
    OnClick = CheckBox1Click
  end
  object RTotalEdit: TEdit
    Left = 48
    Top = 114
    Width = 49
    Height = 21
    TabStop = False
    Color = clSilver
    ReadOnly = True
    TabOrder = 19
    Text = '0.06'
  end
  object R3Edit2: TEdit
    Left = 48
    Top = 85
    Width = 49
    Height = 21
    TabOrder = 12
    Text = '0.03'
    OnChange = R1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object R2Edit2: TEdit
    Left = 48
    Top = 58
    Width = 49
    Height = 21
    TabOrder = 6
    Text = '0.02'
    OnChange = R1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object R1Edit2: TEdit
    Left = 48
    Top = 31
    Width = 49
    Height = 21
    TabOrder = 0
    Text = '0.01'
    OnChange = R1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object T3Edit2: TEdit
    Left = 108
    Top = 85
    Width = 49
    Height = 21
    TabOrder = 13
    Text = '3'
    OnChange = T1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object T2Edit2: TEdit
    Left = 108
    Top = 58
    Width = 49
    Height = 21
    TabOrder = 7
    Text = '2'
    OnChange = T1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object T1Edit2: TEdit
    Left = 108
    Top = 31
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '1'
    OnChange = T1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object K3Edit2: TEdit
    Left = 168
    Top = 85
    Width = 49
    Height = 21
    TabOrder = 14
    Text = '3'
    OnChange = K1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object K2Edit2: TEdit
    Left = 168
    Top = 58
    Width = 49
    Height = 21
    TabOrder = 8
    Text = '2'
    OnChange = K1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object K1Edit2: TEdit
    Left = 168
    Top = 31
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '1'
    OnChange = K1Edit2Change
    OnKeyPress = R1Edit2KeyPress
  end
  object MemoDescription: TMemo
    Left = 3
    Top = 160
    Width = 397
    Height = 41
    TabOrder = 18
    OnChange = MemoDescriptionChange
    OnKeyPress = MemoDescriptionKeyPress
  end
  object EditAI: TEdit
    Left = 351
    Top = 31
    Width = 49
    Height = 21
    TabOrder = 5
    Text = '0.25'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditAM: TEdit
    Left = 231
    Top = 31
    Width = 49
    Height = 21
    TabOrder = 3
    Text = '0.5'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditAR: TEdit
    Left = 291
    Top = 31
    Width = 49
    Height = 21
    TabOrder = 4
    Text = '0.06'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditMonth: TEdit
    Left = 183
    Top = 113
    Width = 49
    Height = 21
    TabStop = False
    Color = clSilver
    Enabled = False
    TabOrder = 20
    Text = '0'
    Visible = False
    OnChange = EditMonthChange
    OnKeyPress = EditMonthKeyPress
  end
  object EditAI2: TEdit
    Left = 351
    Top = 58
    Width = 49
    Height = 21
    TabOrder = 11
    Text = '0.25'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditAM2: TEdit
    Left = 231
    Top = 58
    Width = 49
    Height = 21
    TabOrder = 9
    Text = '0.5'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditAR2: TEdit
    Left = 291
    Top = 58
    Width = 49
    Height = 21
    TabOrder = 10
    Text = '0.06'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditAI3: TEdit
    Left = 351
    Top = 85
    Width = 49
    Height = 21
    TabOrder = 17
    Text = '0.25'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditAM3: TEdit
    Left = 231
    Top = 85
    Width = 49
    Height = 21
    TabOrder = 15
    Text = '0.5'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object EditAR3: TEdit
    Left = 291
    Top = 85
    Width = 49
    Height = 21
    TabOrder = 16
    Text = '0.06'
    Visible = False
    OnChange = EditAIChange
    OnKeyPress = R1Edit2KeyPress
  end
  object SaveDialog1: TSaveDialog
    Filter = '*.CSV|*.CSV'
    Left = 16
    Top = 16
  end
end
