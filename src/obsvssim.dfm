object frmObsVsSimPlot: TfrmObsVsSimPlot
  Left = 249
  Top = 223
  Caption = 'Simulated Peak I/I vs Observed Peak I/I'
  ClientHeight = 279
  ClientWidth = 512
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Top = 8
    object Graph1: TMenuItem
      Caption = 'Graph'
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
    object View1: TMenuItem
      Caption = 'View'
      object oggleColorScheme1: TMenuItem
        Caption = 'Toggle Color Scheme'
        OnClick = oggleColorScheme1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
  end
end
