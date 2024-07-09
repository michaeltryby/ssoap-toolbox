object frmCARDIIRankingGraph2: TfrmCARDIIRankingGraph2
  Left = 0
  Top = 0
  Caption = 'Sewershed Prioritization Analysis Results'
  ClientHeight = 390
  ClientWidth = 601
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
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 601
    Height = 390
    Align = alClient
    Alignment = taCenter
    BiDiMode = bdLeftToRight
    Caption = 'No Data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 57
    ExplicitHeight = 19
  end
  object MainMenu1: TMainMenu
    object Optionx1: TMenuItem
      Caption = 'Options'
      object SavetoText1: TMenuItem
        Caption = 'Save to Text'
        OnClick = SavetoText1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
      object test1: TMenuItem
        Caption = 'test'
        Visible = False
        OnClick = test1Click
      end
    end
  end
  object SaveTextFileDialog1: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Text Files (*.txt)|*.txt'
    Title = 'Export to Text (txt)'
    Left = 120
    Top = 304
  end
end
