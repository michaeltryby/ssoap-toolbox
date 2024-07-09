object frmLinearRegressionAnalysis: TfrmLinearRegressionAnalysis
  Left = 0
  Top = 0
  Caption = 'Linear Regression Analysis'
  ClientHeight = 547
  ClientWidth = 756
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
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
    Height = 547
    Align = alClient
    Alignment = taCenter
    Caption = 'No Data'
    Layout = tlCenter
    ExplicitWidth = 39
    ExplicitHeight = 13
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 56
    object Options1: TMenuItem
      Caption = 'Options'
      object MenuItemSwitchRegressionType: TMenuItem
        Caption = 'Switch to Second-Order Regression'
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
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
  end
end
