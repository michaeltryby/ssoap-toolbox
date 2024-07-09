unit frmTSGrapher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frmTSGraph;

type
  TTSGrapherForm = class(TForm)
    Label2: TLabel;
    ListBoxSelectedNodes: TListBox;
    btnOK: TButton;
    btnHelp: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    Memo1: TMemo;
    ListBoxSSOs: TListBox;
    Label1: TLabel;
    LabelGraphName: TLabel;
    btnCopy2Clipboard: TButton;
    CheckBoxSSOsOnly: TCheckBox;
    btnGraph: TButton;
    CheckBoxScenarioUnits: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxSelectedNodesClick(Sender: TObject);
    procedure ListBoxSSOsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCopy2ClipboardClick(Sender: TObject);
    procedure CheckBoxSSOsOnlyClick(Sender: TObject);
    procedure ListBoxSelectedNodesDblClick(Sender: TObject);
    procedure ListBoxSSOsDblClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure CheckBoxScenarioUnitsClick(Sender: TObject);
    procedure btnGraphClick(Sender: TObject);
  private
    { Private declarations }
    procedure SelectDepthJunction;
    procedure SelectFlowJunction;
  public
    { Public declarations }
    m_scID: integer;
    m_junID, m_flowunitlabel, m_depthunitlabel: string;
    procedure SetScenarioID(scID: integer);
  end;

var
  TSGrapherForm: TTSGrapherForm;

implementation
uses modDatabase, mainform, Clipbrd;

{$R *.dfm}

procedure TTSGrapherForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TTSGrapherForm.btnCopy2ClipboardClick(Sender: TObject);
begin
//copy contents of Listbox to clipboard
  ClipBoard.Clear;
//  ClipBoard.AsText := labelGraphName.Caption + chr(13) + chr(10) + Memo1.Text;
  ClipBoard.AsText := Memo1.Text;
end;

procedure TTSGrapherForm.btnGraphClick(Sender: TObject);
begin
  if ListBoxSelectedNodes.ItemIndex >= 0 then begin
    SelectDepthJunction;
    TSGraphForm.Initialize;
    TSGraphForm.SetScenarioID(m_scID);
    TSGraphForm.SetType('Junction Depth');
    TSGraphForm.SetJunction(ListBoxSelectedNodes.Items[ListBoxSelectedNodes.ItemIndex]);
    TSGraphForm.ShowModal;
  end else if ListBoxSSOs.ItemIndex >= 0 then begin
    SelectFlowJunction;
    TSGraphForm.Initialize;
    TSGraphForm.SetScenarioID(m_scID);
    if (CheckBoxSSOsOnly.Checked) then
      TSGraphForm.SetType('SSO Flow')
    else
      TSGraphForm.SetType('Outfall Flow');
    TSGraphForm.SetJunction(ListBoxSSOs.Items[ListBoxSSOs.ItemIndex]);
    TSGraphForm.ShowModal;
  end;
end;

procedure TTSGrapherForm.btnHelpClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TTSGrapherForm.btnOKClick(Sender: TObject);
begin
  if ListBoxSelectedNodes.ItemIndex >= 0 then begin
    SelectDepthJunction;
    //TSGraphForm.Initialize;
    //TSGraphForm.SetScenarioID(m_scID);
    //TSGraphForm.SetType('Junction Depth');
    //TSGraphForm.SetJunction(ListBoxSelectedNodes.Items[ListBoxSelectedNodes.ItemIndex]);
    //TSGraphForm.ShowModal;
  end else if ListBoxSSOs.ItemIndex >= 0 then begin
    SelectFlowJunction;
    //TSGraphForm.Initialize;
    //TSGraphForm.SetScenarioID(m_scID);
    //if (CheckBoxSSOsOnly.Checked) then
    //  TSGraphForm.SetType('SSO Flow')
    //else
    //  TSGraphForm.SetType('Outfall Flow');
    //TSGraphForm.SetJunction(ListBoxSSOs.Items[ListBoxSSOs.ItemIndex]);
    //TSGraphForm.ShowModal;
  end;
end;

procedure TTSGrapherForm.CheckBoxScenarioUnitsClick(Sender: TObject);
begin
  btnOKClick(Sender);
end;

procedure TTSGrapherForm.CheckBoxSSOsOnlyClick(Sender: TObject);
//toggle SSOs Only
var
  lstSSOs: TStringList;
  i: integer;
begin
  ListBoxSSOs.Clear;
  //fill ListBoxSSOs
  lstSSOs := DataBaseModule.GetOutfallJunctionsbyScenario(m_scID, not CheckBoxSSOsOnly.Checked, true);
  ListBoxSSOs.Items.AddStrings(lstSSOs);
end;

procedure TTSGrapherForm.FormCreate(Sender: TObject);
begin
  m_scID := -1;
  m_JunID := '';
end;

procedure TTSGrapherForm.ListBoxSelectedNodesClick(Sender: TObject);
begin
  ListBoxSSOs.ClearSelection;
  ListBoxSSOs.ItemIndex := -1;
end;

procedure TTSGrapherForm.ListBoxSelectedNodesDblClick(Sender: TObject);
begin
//if there is a selection, graph it
  SelectDepthJunction;
end;

procedure TTSGrapherForm.ListBoxSSOsClick(Sender: TObject);
begin
  ListBoxSelectedNodes.ClearSelection;
  ListBoxSelectedNodes.ItemIndex := -1;
end;

procedure TTSGrapherForm.ListBoxSSOsDblClick(Sender: TObject);
begin
  SelectFlowJunction;
end;

procedure TTSGrapherForm.SelectDepthJunction;
var
  theList: TStringList;
  i: integer;
begin
   Memo1.Visible := False;
  try
  Memo1.Lines.Clear;
  if ListBoxSelectedNodes.ItemIndex >= 0 then begin
    m_junID := ListBoxSelectedNodes.Items[ListboxSelectedNodes.ItemIndex];
    //if (CheckBoxScenarioUnits.Checked) then begin
    //  m_depthunitlabel := DatabaseModule.GetDepthUnitLabelForScenario(m_scID);
    //end else begin
      m_depthunitlabel := DatabaseModule.GetJuncDepthTSUnitLabel(m_scID, m_junID, i);
    //end;
    labelgraphName.Caption := m_junID + ' Junction Depth (' + m_depthunitlabel + ')';
    Memo1.Lines.Add('Date_Time,' + m_junID + '_Depth(' + m_depthunitlabel + ')');
    theList := DatabaseModule.GetJuncDepthTS(m_scID, m_junID, CheckBoxScenarioUnits.Checked);
    for i := 0 to theList.Count - 1 do
      Memo1.Lines.Add(theList[i]);
  end;
  finally
    Memo1.Visible := true;
  end;
end;

procedure TTSGrapherForm.SelectFlowJunction;
var
  theList: TStringList;
  i: integer;
begin
  Memo1.Visible := False;
  try
  Memo1.Lines.Clear;
  if ListBoxSSOs.ItemIndex >= 0 then begin
    m_junID := ListBoxSSOs.Items[ListboxSSOs.ItemIndex];
    //m_flowunitlabel := DatabaseModule.GetJuncFlowTSUnitLabel(m_scID, m_junID, i);
    if (CheckBoxScenarioUnits.Checked) then begin
      m_flowunitlabel := DatabaseModule.GetFlowUnitLabelForScenario(m_scID);
    end else begin
      m_flowunitlabel := DatabaseModule.GetJuncFlowTSUnitLabel(m_scID, m_junID, i);
    end;
    labelgraphName.Caption := m_junID + ' Outfall Flow (' + m_flowunitlabel + ')';
    Memo1.Lines.Add('Date_Time,' + m_junID + '_Flow(' + m_flowunitlabel + ')');
    theList := DatabaseModule.GetJuncFlowTS(m_scID, m_junID, CheckBoxScenarioUnits.Checked);
    for i := 0 to theList.Count - 1 do
      Memo1.Lines.Add(theList[i]);
  end;
  finally
    Memo1.Visible := true;
  end;
end;

procedure TTSGrapherForm.SetScenarioID(scID: integer);
var
  lstSSOs, lstSelectedNodes: TStringList;
  i: integer;
  sUnitLabel: string;
begin
  m_scID := scID;
  m_flowunitlabel := DatabaseModule.GetFlowUnitLabelForScenario(m_scID);
  CheckBoxScenarioUnits.Caption := 'Use Scenario Units (' + m_flowunitlabel + ')';
  Memo1.Lines.Clear;
  ListBoxSelectedNodes.Clear;
  ListBoxSSOs.Clear;
  //fill ListBoxOutfalls and ListBoxSSOs
  lstSelectedNodes := DataBaseModule.GetJunctionsbyScenario(scID, ' (JunctionDepthTS = TRUE) ');
  ListBoxSelectedNodes.Items.AddStrings(lstSelectedNodes);
  lstSSOs := DataBaseModule.GetOutfallJunctionsbyScenario(scID, not CheckBoxSSOsOnly.Checked, true);
  ListBoxSSOs.Items.AddStrings(lstSSOs);
end;

end.
