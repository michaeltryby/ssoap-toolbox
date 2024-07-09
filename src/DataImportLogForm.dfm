object frmDataImportLog: TfrmDataImportLog
  Left = 0
  Top = 0
  Caption = 'Data Import Log'
  ClientHeight = 386
  ClientWidth = 706
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    706
    386)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 690
    Height = 342
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 0
    DesignSize = (
      690
      342)
    object StringGrid1: TStringGrid
      Left = 8
      Top = 8
      Width = 673
      Height = 326
      Anchors = [akLeft, akTop, akRight, akBottom]
      ColCount = 10
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
      TabOrder = 0
      OnDblClick = StringGrid1DblClick
      OnMouseUp = StringGrid1MouseUp
    end
  end
  object TabSet1: TTabSet
    Left = 8
    Top = 357
    Width = 690
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Tabs.Strings = (
      'All Imports'
      'Rainfall'
      'Flows'
      'Sewersheds'
      'RDII Areas'
      'RTK Patterns'
      'SWMM 5 Imports')
    TabIndex = 0
    OnChange = TabSet1Change
  end
end
