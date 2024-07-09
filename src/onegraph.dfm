object frmManualDWFDaySelection: TfrmManualDWFDaySelection
  Left = 320
  Top = 160
  ClientHeight = 310
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnDblClick = FormDblClick
  OnKeyUp = FormKeyUp
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 512
    Top = 8
    object Graph1: TMenuItem
      Caption = 'Graph'
      object KeepMenuOption: TMenuItem
        Caption = 'Keep'
        ShortCut = 16459
        OnClick = KeepMenuOptionClick
      end
      object DiscardMenuOption: TMenuItem
        Caption = 'Discard'
        ShortCut = 16452
        OnClick = DiscardMenuOptionClick
      end
      object UpdateADWF1: TMenuItem
        Caption = 'Update ADWF'
        ShortCut = 16469
        OnClick = UpdateADWF1Click
      end
      object StopMenuOption: TMenuItem
        Caption = 'Stop'
        ShortCut = 16467
        OnClick = StopMenuOptionClick
      end
    end
    object Navigation1: TMenuItem
      Caption = 'Navigation'
      object PreviousMenuOption: TMenuItem
        Caption = 'Previous'
        ShortCut = 16464
        OnClick = PreviousMenuOptionClick
      end
      object NextMenuOption: TMenuItem
        Caption = 'Next'
        ShortCut = 16462
        OnClick = NextMenuOptionClick
      end
      object BeginingMenuOption: TMenuItem
        Caption = 'Beginning'
        ShortCut = 16450
        OnClick = BeginingMenuOptionClick
      end
      object EndMenuOption: TMenuItem
        Caption = 'End'
        ShortCut = 16453
        OnClick = EndMenuOptionClick
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object N1x1MenuOption: TMenuItem
        Caption = '1x1'
        Checked = True
        GroupIndex = 10
        RadioItem = True
        OnClick = N1x1MenuOptionClick
      end
      object N1x2MenuOption: TMenuItem
        Caption = '1x2'
        GroupIndex = 10
        RadioItem = True
        OnClick = N1x2MenuOptionClick
      end
      object n1x3MenuOption: TMenuItem
        Caption = '1x3'
        GroupIndex = 10
        RadioItem = True
        OnClick = n1x3MenuOptionClick
      end
      object N2x2MenuOption: TMenuItem
        Caption = '2x2'
        GroupIndex = 10
        RadioItem = True
        OnClick = N2x2MenuOptionClick
      end
      object N2x3MenuOption: TMenuItem
        Caption = '2x3'
        GroupIndex = 10
        RadioItem = True
        OnClick = N2x3MenuOptionClick
      end
      object N3x3MenuOption: TMenuItem
        Caption = '3x3'
        GroupIndex = 10
        RadioItem = True
        OnClick = N3x3MenuOptionClick
      end
    end
    object HelpMenuOption: TMenuItem
      Caption = 'Help'
      OnClick = HelpMenuOptionClick
    end
  end
end
