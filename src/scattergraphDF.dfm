object frmScatterGraphDF: TfrmScatterGraphDF
  Left = 242
  Top = 146
  Caption = 'Depth-Flow Scatter Graph'
  ClientHeight = 459
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseWheelDown = FormMouseWheelDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object File1: TMenuItem
      Caption = 'Print'
      object PrintPreview1: TMenuItem
        Caption = 'Print Preview...'
        OnClick = PrintPreview1Click
      end
      object Print1: TMenuItem
        Caption = 'Print...'
        OnClick = Print1Click
      end
      object ToggleColorScheme1: TMenuItem
        Caption = 'Toggle Color Scheme'
        OnClick = ToggleColorScheme1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object CopyToClipboard1: TMenuItem
        Caption = 'Copy To Clipboard'
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
