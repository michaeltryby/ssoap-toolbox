unit frmNodeDepthSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TNodeSelectorForm = class(TForm)
    btnOK: TButton;
    btnHelp: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBoxNodes: TListBox;
    ListBoxSelectedNodes: TListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    m_scID: integer;
    m_bo_Changed_Junction_List: boolean;
    function GetJunctionCount:integer;
    function GetSelectedJunctionCount:integer;
    procedure SetScenarioID(scID: integer; bo_ICareAboutWhatsAlreadyLoaded: boolean);
  end;

var
  NodeSelectorForm: TNodeSelectorForm;

implementation
uses modDatabase, mainform;

{$R *.dfm}

procedure TNodeSelectorForm.btnAddClick(Sender: TObject);
var i: integer;
begin
//  if ListBoxOutfalls.SelCount > 0 then begin
    for i := 0 to ListBoxNodes.Count - 1 do begin
      if ListBoxNodes.Selected[i] then begin
        ListBoxSelectedNodes.Items.Add(ListBoxNodes.Items[i]);
      end;
    end;
    for i := ListBoxNodes.Count - 1 downto 0 do begin
      if ListBoxNodes.Selected[i] then begin
        ListBoxNodes.Items.Delete(i);
      end;
    end;
    m_bo_Changed_Junction_List := true;
//  end;
end;

procedure TNodeSelectorForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TNodeSelectorForm.btnHelpClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TNodeSelectorForm.btnOKClick(Sender: TObject);
var i: integer;
begin
try
  for i := 0 to ListBoxSelectedNodes.Count - 1 do begin
    databaseModule.SetJunctionDepthTS(m_scID, ListBoxSelectedNodes.Items[i],True);
  end;
finally

end;
try
  for i := 0 to ListBoxNodes.Count - 1 do begin
    databaseModule.SetJunctionDepthTS(m_scID, ListBoxNodes.Items[i],False);
  end;
finally

end;
  Close;
end;

procedure TNodeSelectorForm.btnRemoveClick(Sender: TObject);
var i: integer;
begin
//  if ListBoxSSOs.SelCount > 0 then begin
    for i := 0 to ListBoxSelectedNodes.Count - 1 do begin
      if ListBoxSelectedNodes.Selected[i] then begin
        ListBoxNodes.Items.Add(ListBoxSelectedNodes.Items[i]);
      end;
    end;
    for i := ListBoxSelectedNodes.Count - 1 downto 0 do begin
      if ListBoxSelectedNodes.Selected[i] then begin
        ListBoxSelectedNodes.Items.Delete(i);
      end;
    end;
    m_bo_Changed_Junction_List := true;
//  end;
end;

procedure TNodeSelectorForm.FormCreate(Sender: TObject);
begin
  m_scID := -1;
end;

procedure TNodeSelectorForm.FormShow(Sender: TObject);
begin
    m_bo_Changed_Junction_List := false;
end;

function TNodeSelectorForm.GetJunctionCount: integer;
begin
  if (m_scID > 0) then
    GetJunctionCount :=
      ListBoxSelectedNodes.Items.Count + ListBoxNodes.Items.Count
  else
    GetJunctionCount := m_scID;
end;

function TNodeSelectorForm.GetSelectedJunctionCount: integer;
begin
  if (m_scID > 0) then
    GetSelectedJunctionCount := ListBoxSelectedNodes.Items.Count
  else
    GetSelectedJunctionCount := m_scID;
end;

procedure TNodeSelectorForm.SetScenarioID(scID: integer; bo_ICareAboutWhatsAlreadyLoaded: boolean);
var
  lstNodes, lstSelectedNodes: TStringList;
  i: integer;
begin
  if (bo_ICareAboutWhatsAlreadyLoaded and (scID = m_scID)) then begin
    if (ListBoxSelectedNodes.Items.Count > 0) then begin
      //there are some selections already in listbox
      for I := 0 to ListBoxSelectedNodes.Items.Count - 1 do begin
        //set the selected flag for junctions in this listbox
        databaseModule.SetJunctionDepthTS(m_scID, ListBoxSelectedNodes.Items[i], True);
      end;
    end;
  end;
  m_scID := scID;
  ListBoxNodes.Clear;
  ListBoxSelectedNodes.Clear;
  //fill ListBoxOutfalls and ListBoxSSOs
  lstNodes := DataBaseModule.GetJunctionsbyScenario(scID, ' (JunctionDepthTS = FALSE) ');
  lstSelectedNodes := DataBaseModule.GetJunctionsbyScenario(scID, ' (JunctionDepthTS = TRUE) ');
  ListBoxNodes.Items.AddStrings(lstNodes);
  ListBoxSelectedNodes.Items.AddStrings(lstSelectedNodes);
end;

end.
