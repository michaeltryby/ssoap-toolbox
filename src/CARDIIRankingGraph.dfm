object frmCARDIIRankingGraph: TfrmCARDIIRankingGraph
  Left = 0
  Top = 0
  Caption = 'Prioritization for Field Investigation'
  ClientHeight = 350
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
    Height = 350
    Align = alClient
    Alignment = taCenter
    BiDiMode = bdLeftToRight
    Caption = 'No Data'
    ParentBiDiMode = False
    Layout = tlCenter
    ExplicitWidth = 39
    ExplicitHeight = 13
  end
  object MainMenu1: TMainMenu
    object Optionx1: TMenuItem
      Caption = 'Options'
      object EventSimulatedR1R2andR31: TMenuItem
        AutoCheck = True
        Caption = 'Event Simulated R1, R2, and R3'
        Checked = True
        RadioItem = True
        OnClick = EventSimulatedR1R2andR31Click
      end
      object ObservedRTotal1: TMenuItem
        AutoCheck = True
        Caption = 'Observed R Total'
        RadioItem = True
        OnClick = ObservedRTotal1Click
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
