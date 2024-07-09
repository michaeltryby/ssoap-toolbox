object frmDryWeatherHydrographsForm: TfrmDryWeatherHydrographsForm
  Left = 264
  Top = 251
  Caption = 'Dry Weather Hydrographs'
  ClientHeight = 374
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Top = 8
    object Graph1: TMenuItem
      Caption = 'Graph'
      object Weekdays1: TMenuItem
        Caption = '&Weekdays'
        Checked = True
        ShortCut = 16471
        OnClick = Weekdays1Click
      end
      object Weekends1: TMenuItem
        Caption = 'Week&ends'
        Checked = True
        ShortCut = 16453
        OnClick = Weekends1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = '&Close'
        OnClick = Close1Click
      end
    end
    object Print1: TMenuItem
      Caption = 'Print'
      object PrintPreview1: TMenuItem
        Caption = 'Print Preview...'
        OnClick = PrintPreview1Click
      end
      object Print2: TMenuItem
        Caption = 'Print...'
        OnClick = Print2Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object CopytoClipboard1: TMenuItem
        Caption = 'Copy to Clipboard'
        object AsaBitmap1: TMenuItem
          Caption = 'As a Bitmap'
          OnClick = AsaBitmap1Click
        end
        object AsaMetafile1: TMenuItem
          Caption = 'As a Metafile'
          OnClick = AsaMetafile1Click
        end
        object AsTextdataonly1: TMenuItem
          Caption = 'As Text (data only)'
          OnClick = AsTextdataonly1Click
        end
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
  end
end
