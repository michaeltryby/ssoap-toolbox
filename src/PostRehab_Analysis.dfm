object frmPostRehab_Analysis: TfrmPostRehab_Analysis
  Left = 0
  Top = 0
  Caption = 
    'Pre- and Post- Sewer Rehabilitation RDII Correlation Analysis Re' +
    'sults'
  ClientHeight = 553
  ClientWidth = 756
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 756
    Height = 553
    Align = alClient
    Alignment = taCenter
    Caption = 'No Data'
    Layout = tlCenter
    ExplicitWidth = 39
    ExplicitHeight = 13
  end
  object Label2: TLabel
    Left = 464
    Top = 120
    Width = 152
    Height = 22
    Caption = 'RDII Reduction ='
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 56
    object Options1: TMenuItem
      Caption = 'Options'
      object MenuItemSwitchRegressionType: TMenuItem
        Caption = 'Switch to Second-Order Regression'
        Visible = False
        OnClick = MenuItemSwitchRegressionTypeClick
      end
      object oggleColorScheme1: TMenuItem
        Caption = 'Toggle Color Scheme'
        OnClick = oggleColorScheme1Click
      end
      object Export1: TMenuItem
        Caption = 'Export'
        Visible = False
        OnClick = Export1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object TotalRobserved1: TMenuItem
        AutoCheck = True
        Caption = 'Total R'
        Checked = True
        RadioItem = True
        OnClick = TotalRobserved1Click
      end
      object TotalRsimulated1: TMenuItem
        AutoCheck = True
        Caption = 'Total R (with R1, R2, && R3 distribution)'
        RadioItem = True
        OnClick = TotalRsimulated1Click
      end
      object R11: TMenuItem
        AutoCheck = True
        Caption = 'R1'
        RadioItem = True
        OnClick = R11Click
      end
      object R21: TMenuItem
        AutoCheck = True
        Caption = 'R2'
        RadioItem = True
        OnClick = R21Click
      end
      object R31: TMenuItem
        AutoCheck = True
        Caption = 'R3'
        RadioItem = True
        OnClick = R31Click
      end
      object R2R31: TMenuItem
        AutoCheck = True
        Caption = 'R2 + R3'
        RadioItem = True
        OnClick = R2R31Click
      end
      object PeakRDIIperArea1: TMenuItem
        AutoCheck = True
        Caption = 'Peak RDII per Area'
        RadioItem = True
        OnClick = PeakRDIIperArea1Click
      end
      object RDIIperLF1: TMenuItem
        AutoCheck = True
        Caption = 'RDII per LF'
        RadioItem = True
        OnClick = RDIIperLF1Click
      end
      object RDIIperAverageDWF1: TMenuItem
        AutoCheck = True
        Caption = 'RDII per Average Weekday DWF'
        RadioItem = True
        OnClick = RDIIperAverageDWF1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
  end
end
