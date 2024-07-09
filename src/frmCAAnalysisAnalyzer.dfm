object frmCAAnalysesAnalyzer: TfrmCAAnalysesAnalyzer
  Left = 0
  Top = 0
  Caption = 'Condition Assessment Analyses Analyzer'
  ClientHeight = 411
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    509
    411)
  PixelsPerInch = 96
  TextHeight = 13
  object MemoOlapAnalyzer: TMemo
    Left = 8
    Top = 24
    Width = 493
    Height = 327
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ButtonOK: TButton
    Left = 160
    Top = 366
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 272
    Top = 366
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
end
