unit frmSSOOutfallSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSSOOutfallForm = class(TForm)
    btnOK: TButton;
    btnHelp: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBoxOutfalls: TListBox;
    ListBoxSSOs: TListBox;
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
    m_bo_Changed_SSO_List: boolean;
    function GetSSOCount: integer;
    procedure SetScenarioID(scID: integer; bo_ICareAboutWhatsAlreadyLoaded: boolean);
  end;

var
  SSOOutfallForm: TSSOOutfallForm;

implementation
uses modDatabase, mainform;

{$R *.dfm}

procedure TSSOOutfallForm.btnAddClick(Sender: TObject);
var i: integer;
begin
//  if ListBoxOutfalls.SelCount > 0 then begin
    for i := 0 to ListBoxOutfalls.Count - 1 do begin
      if ListBoxOutfalls.Selected[i] then begin
        ListBoxSSOs.Items.Add(ListBoxOutfalls.Items[i]);
      end;
    end;
    for i := ListBoxOutfalls.Count - 1 downto 0 do begin
      if ListBoxOutfalls.Selected[i] then begin
        ListBoxOutfalls.Items.Delete(i);
      end;
    end;
    m_bo_Changed_SSO_List := true;
//  end;
end;

procedure TSSOOutfallForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TSSOOutfallForm.btnHelpClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TSSOOutfallForm.btnOKClick(Sender: TObject);
var i: integer;
begin
try
  for i := 0 to ListBoxSSOs.Count - 1 do begin
    databaseModule.SetJunctionSSO(m_scID, ListBoxSSOs.Items[i],True);
  end;
finally

end;
try
  for i := 0 to ListBoxOutfalls.Count - 1 do begin
    databaseModule.SetJunctionSSO(m_scID, ListBoxOutfalls.Items[i],False);
  end;
finally

end;
  Close;
end;

procedure TSSOOutfallForm.btnRemoveClick(Sender: TObject);
var i: integer;
begin
//  if ListBoxSSOs.SelCount > 0 then begin
    for i := 0 to ListBoxSSOs.Count - 1 do begin
      if ListBoxSSOs.Selected[i] then begin
        ListBoxOutfalls.Items.Add(ListBoxSSOs.Items[i]);
      end;
    end;
    for i := ListBoxSSOs.Count - 1 downto 0 do begin
      if ListBoxSSOs.Selected[i] then begin
        ListBoxSSOs.Items.Delete(i);
      end;
    end;
    m_bo_Changed_SSO_List := true;
//  end;
end;

procedure TSSOOutfallForm.FormCreate(Sender: TObject);
begin
  m_scID := -1;
end;

procedure TSSOOutfallForm.FormShow(Sender: TObject);
begin
  m_bo_Changed_SSO_List := false;
end;

function TSSOOutfallForm.GetSSOCount: integer;
begin
  if (m_scID > 0) then
    GetSSOCount := ListBoxSSOs.Items.Count
  else
    GetSSOCount := m_scID;
end;

procedure TSSOOutfallForm.SetScenarioID(scID: integer; bo_ICareAboutWhatsAlreadyLoaded: boolean);
var
  lstOutfalls, lstSSOs: TStringList;
  i: integer;
begin
  if (bo_ICareAboutWhatsAlreadyLoaded and (scID = m_scID)) then begin
    if (ListBoxSSOs.Items.Count > 0) then begin
      //there are some selections already in listbox
      for I := 0 to ListBoxSSOs.Items.Count - 1 do begin
        //set the isSSO flag for outfalls in this listbox
        databaseModule.SetJunctionSSO(m_scID, ListBoxSSOs.Items[i], True);
      end;
    end;
  end;
  m_scID := scID;
  listboxOutfalls.Clear;
  listboxSSOs.Clear;
  //fill ListBoxOutfalls and ListBoxSSOs
  lstOutfalls := DataBaseModule.GetOutfallJunctionsbyScenario(scID, true, false);
  lstSSOs := DataBaseModule.GetOutfallJunctionsbyScenario(scID, false, true);
  ListBoxOutfalls.Items.AddStrings(lstOutfalls);
  ListBoxSSOs.Items.AddStrings(lstSSOs);
end;

end.
