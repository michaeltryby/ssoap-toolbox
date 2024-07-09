unit CAChooseAnalyses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmCAAnalysesSelector = class(TForm)
    Label1: TLabel;
    AnalysisNameComboBox1: TComboBox;
    okButton: TButton;
    helpButton: TButton;
    btnClose: TButton;
    Label2: TLabel;
    AnalysisNameComboBox2: TComboBox;
    Label3: TLabel;
    AnalysisNameComboBox3: TComboBox;
    Label4: TLabel;
    AnalysisNameComboBox4: TComboBox;
    Label5: TLabel;
    Edit1: TEdit;
    btnDetails1: TButton;
    btnDetails2: TButton;
    btnDetails3: TButton;
    btnDetails4: TButton;
    Label6: TLabel;
    UpDown1: TUpDown;
    EditOlapTol: TEdit;
    ButtonAnalyze: TButton;
    Label7: TLabel;
    Label8: TLabel;
    procedure ButtonAnalyzeClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure EditOlapTolKeyPress(Sender: TObject; var Key: Char);
    procedure btnDetails1Click(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private { Private declarations }
    FMode: string;
    FCAID: integer;
    OrigName: string;
    OrigAnal1: string;
    OrigAnal2: string;
    OrigAnal3: string;
    OrigAnal4: string;
    OrigOlapTol: string;
  public { Public declarations }
    property Mode: string read FMode write FMode;
    property CAID: integer read FCAID write FCAID;
    function SelectedAnalysis(sMode: string): string;
    procedure SetCA;
  end;

var
  frmCAAnalysesSelector: TfrmCAAnalysesSelector;

implementation

uses modDatabase, mainform, analysismanager, editanalysis, StormEventCollection,
  frmCAAnalysisAnalyzer, infoanalysis;

{$R *.DFM}

procedure TfrmCAAnalysesSelector.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCAAnalysesSelector.btnDetails1Click(Sender: TObject);
begin
//rm 2011-03-15
  frmEditAnalysis.Caption := 'Analysis Details';
  if (Sender = btnDetails1) then begin
    frmAnalysisManagement.SelectedAnalysisName := AnalysisNameComboBox1.Text;
    frmInfoAnalysis.ShowModal;
  end else if (Sender = btnDetails2) then begin
    frmAnalysisManagement.SelectedAnalysisName := AnalysisNameComboBox2.Text;
    frmInfoAnalysis.ShowModal;
  end else if (Sender = btnDetails3) then begin
    frmAnalysisManagement.SelectedAnalysisName := AnalysisNameComboBox3.Text;
    frmInfoAnalysis.ShowModal;
  end else if (Sender = btnDetails4) then begin
    frmAnalysisManagement.SelectedAnalysisName := AnalysisNameComboBox4.Text;
    frmInfoAnalysis.ShowModal;
  end;
  frmInfoAnalysis.Caption := 'Edit Analysis';
end;

procedure TfrmCAAnalysesSelector.ButtonAnalyzeClick(Sender: TObject);
begin
  //Analyze the overlap of Events from 1 to 2 and 3 to 4
  //. . . . |---------| . . . . |-----------------| . . . .
  //. . . . . |-------| . . . . . . |-----------------| . .
  (*
  analysisID1 := DatabaseModule.GetAnalysisIDForName(AnalysisNameCombobox1.Text);
  events1 := DatabaseModule.GetEvents(analysisID1);
  analysisID2 := DatabaseModule.GetAnalysisIDForName(AnalysisNameCombobox2.Text);
  events2 := DatabaseModule.GetEvents(analysisID2);
  analysisID3 := DatabaseModule.GetAnalysisIDForName(AnalysisNameCombobox3.Text);
  events3 := DatabaseModule.GetEvents(analysisID3);
  analysisID4 := DatabaseModule.GetAnalysisIDForName(AnalysisNameCombobox4.Text);
  events4 := DatabaseModule.GetEvents(analysisID4);
  *)
  frmCAAnalysesAnalyzer.SetAnalyses(AnalysisNameCombobox1.Text,AnalysisNameCombobox2.Text,
          AnalysisNameCombobox3.Text,AnalysisNameCombobox4.Text, StrToInt(EditOlapTol.Text));
  frmCAAnalysesAnalyzer.ShowModal;
end;

procedure TfrmCAAnalysesSelector.EditOlapTolKeyPress(Sender: TObject;
  var Key: Char);
begin
  if sender is TEdit then begin
    if Key in [#3, #22, #8, '0'..'9'] then exit;
    Key := #0;
  end;
end;

procedure TfrmCAAnalysesSelector.FormShow(Sender: TObject);
var i: integer;
  oldval: string;
begin
  i := AnalysisNameComboBox1.ItemIndex;
  if (i > -1) and (i < AnalysisNameComboBox1.Items.Count) then
    oldval := AnalysisNameComboBox1.Items[i]
  else
    oldval := '';
  AnalysisNameComboBox1.Items := DatabaseModule.GetAnalysisNames;
  if (i > -1) and (i < AnalysisNameComboBox1.Items.Count) then begin
    AnalysisNameComboBox1.ItemIndex := i;
  end else begin
    AnalysisNameComboBox1.ItemIndex := 0;
  end;

  i := AnalysisNameComboBox2.ItemIndex;
  if (i > -1) and (i < AnalysisNameComboBox2.Items.Count) then
    oldval := AnalysisNameComboBox2.Items[i]
  else
    oldval := '';
  AnalysisNameComboBox2.Items := AnalysisNameComboBox1.Items;
  if (i > -1) and (i < AnalysisNameComboBox2.Items.Count) then begin
    AnalysisNameComboBox2.ItemIndex := i;
  end else begin
    AnalysisNameComboBox2.ItemIndex := 0;
  end;

  i := AnalysisNameComboBox3.ItemIndex;
  if (i > -1) and (i < AnalysisNameComboBox3.Items.Count) then
    oldval := AnalysisNameComboBox3.Items[i]
  else
    oldval := '';
  AnalysisNameComboBox3.Items := AnalysisNameComboBox1.Items;
  if (i > -1) and (i < AnalysisNameComboBox3.Items.Count) then begin
    AnalysisNameComboBox3.ItemIndex := i;
  end else begin
    AnalysisNameComboBox3.ItemIndex := 0;
  end;

  i := AnalysisNameComboBox4.ItemIndex;
  if (i > -1) and (i < AnalysisNameComboBox4.Items.Count) then
    oldval := AnalysisNameComboBox4.Items[i]
  else
    oldval := '';
  AnalysisNameComboBox4.Items := AnalysisNameComboBox1.Items;
  if (i > -1) and (i < AnalysisNameComboBox4.Items.Count) then begin
    AnalysisNameComboBox4.ItemIndex := i;
  end else begin
    AnalysisNameComboBox4.ItemIndex := 0;
  end;

  if (FMode = 'Edit') then begin
    if (CAID > 0) then begin
      OrigName := databaseModule.GetCAName4CAID(CAID);
      OrigAnal1 := databaseModule.GetAnalysisName4CAID(CAID,1);
      OrigAnal2 := databaseModule.GetAnalysisName4CAID(CAID,2);
      OrigAnal3 := databaseModule.GetAnalysisName4CAID(CAID,3);
      OrigAnal4 := databaseModule.GetAnalysisName4CAID(CAID,4);

      OrigOlapTol := databaseModule.GetOlapTol4CAID(CAID);

      Edit1.Text := OrigName;
      AnalysisNameComboBox1.ItemIndex := AnalysisNameComboBox1.Items.IndexOf(OrigAnal1);
      AnalysisNameComboBox2.ItemIndex := AnalysisNameComboBox2.Items.IndexOf(OrigAnal2);
      AnalysisNameComboBox3.ItemIndex := AnalysisNameComboBox3.Items.IndexOf(OrigAnal3);
      AnalysisNameComboBox4.ItemIndex := AnalysisNameComboBox4.Items.IndexOf(OrigAnal4);

      EditOlapTol.Text := OrigOlapTol;

    end;
    Caption := 'Edit Pre- & Post- Sewer Rehabilitation RDII Correlation Analysis';
  end else if (FMode = 'Add') then begin
    Caption := 'New Pre- & Post- Sewer Rehabilitation RDII Correlation Analysis';
  end else if (FMode = 'View') then begin
    Caption := 'View RDII Correlation Analysis';
    if (CAID > 0) then begin
      OrigName := databaseModule.GetCAName4CAID(CAID);
      OrigAnal1 := databaseModule.GetAnalysisName4CAID(CAID,1);
      OrigAnal2 := databaseModule.GetAnalysisName4CAID(CAID,2);
      OrigAnal3 := databaseModule.GetAnalysisName4CAID(CAID,3);
      OrigAnal4 := databaseModule.GetAnalysisName4CAID(CAID,4);
      OrigOlapTol := databaseModule.GetOlapTol4CAID(CAID);

      Edit1.Text := OrigName;
      AnalysisNameComboBox1.ItemIndex := AnalysisNameComboBox1.Items.IndexOf(OrigAnal1);
      AnalysisNameComboBox2.ItemIndex := AnalysisNameComboBox2.Items.IndexOf(OrigAnal2);
      AnalysisNameComboBox3.ItemIndex := AnalysisNameComboBox3.Items.IndexOf(OrigAnal3);
      AnalysisNameComboBox4.ItemIndex := AnalysisNameComboBox4.Items.IndexOf(OrigAnal4);
      EditOlapTol.Text := OrigOlapTol;

    end else begin


    end;
  end;

//begin
//  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
//  AnalysisNameComboBox.ItemIndex := 0;
end;

procedure TfrmCAAnalysesSelector.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmCAAnalysesSelector.okButtonClick(Sender: TObject);
var id: integer;
  mResult: integer;
begin

  frmCAAnalysesAnalyzer.SetAnalyses(AnalysisNameCombobox1.Text,AnalysisNameCombobox2.Text,
          AnalysisNameCombobox3.Text,AnalysisNameCombobox4.Text, StrToInt(EditOlapTol.Text));
  //rm 2012-08-23 frmCAAnalysesAnalyzer.ShowModal;
  //frmCAAnalysesAnalyzer.Show;

  mResult := mrNone;
  if (Length(Edit1.Text) < 1) then begin
    MessageDlg('Error - Please enter a name for the Condition Assessment.',
    mtError, [mbOK], 0);
  end else begin
  if (FMode = 'Add') then begin
    id := databaseModule.GetCAID4Name(Edit1.Text);
    if (id > -1) then begin
      MessageDlg('Error - Please enter a unique name for the new Condition Assessment.',
      mtError, [mbOK], 0);
    end else begin
      databaseModule.AddConditionAssessment(Edit1.Text);
      OrigName := Edit1.Text;
      CAID := databaseModule.GetCAID4Name(OrigName);
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis1', '"' + AnalysisNameComboBox1.Text + '"');
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis2', '"' + AnalysisNameComboBox2.Text + '"');
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis3', '"' + AnalysisNameComboBox3.Text + '"');
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis4', '"' + AnalysisNameComboBox4.Text + '"');
      databaseModule.UpdateConditionAssessment(CAID, 'OverlapTol', EditOlapTol.Text);

      frmCAAnalysesAnalyzer.SetAnalyses(AnalysisNameCombobox1.Text,AnalysisNameCombobox2.Text,
          AnalysisNameCombobox3.Text,AnalysisNameCombobox4.Text, StrToInt(EditOlapTol.Text));
      mResult := mrOK;
    end;
  end else if (FMode = 'Edit') then begin
  //edit the existing record;
    if (OrigName <> Edit1.Text) then begin
      id := databaseModule.GetCAID4Name(Edit1.Text);
      if (id > -1) then begin
        MessageDlg('Error - Please enter a unique name for the new ConditionAssessment.',
        mtError, [mbOK], 0);
        exit;
      end else begin
      //rm 2012-04-18 - must have quotes around name
        databaseModule.UpdateConditionAssessment(CAID, 'CAName', '"' + Edit1.Text + '"');
        mResult := mrOK;
      end;
    end;
    if (OrigAnal1 <> AnalysisNameComboBox1.Text) then begin
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis1', '"' + AnalysisNameComboBox1.Text + '"');
      mResult := mrOK;
    end;
    if (OrigAnal2 <> AnalysisNameComboBox2.Text) then begin
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis2', '"' + AnalysisNameComboBox2.Text + '"');
      mResult := mrOK;
    end;
    if (OrigAnal3 <> AnalysisNameComboBox3.Text) then begin
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis3', '"' + AnalysisNameComboBox3.Text + '"');
      mResult := mrOK;
    end;
    if (OrigAnal4 <> AnalysisNameComboBox4.Text) then begin
      databaseModule.UpdateConditionAssessment(CAID, 'Analysis4', '"' + AnalysisNameComboBox4.Text + '"');
      mResult := mrOK;
    end;
    if (OrigOlapTol <> EditOlapTol.Text) then begin
      databaseModule.UpdateConditionAssessment(CAID, 'OverlapTol', EditOlapTol.Text);
      mResult := mrOK;
    end;
    mResult := mrOK;
  end;
  end;
  ModalResult := mResult;
end;

function TfrmCAAnalysesSelector.SelectedAnalysis(sMode: string): string;
begin
  if (sMode = '1') then
    SelectedAnalysis := AnalysisNameComboBox1.Items.Strings[AnalysisNameComboBox1.ItemIndex]
  else if (sMode = '2') then
    SelectedAnalysis := AnalysisNameComboBox2.Items.Strings[AnalysisNameComboBox2.ItemIndex]
  else if (sMode = '3') then
    SelectedAnalysis := AnalysisNameComboBox3.Items.Strings[AnalysisNameComboBox3.ItemIndex]
  else if (sMode = '4') then
    SelectedAnalysis := AnalysisNameComboBox4.Items.Strings[AnalysisNameComboBox4.ItemIndex]
end;


procedure TfrmCAAnalysesSelector.SetCA;
begin

end;

procedure TfrmCAAnalysesSelector.UpDown1Click(Sender: TObject;
  Button: TUDBtnType);
var
  i: integer;
begin
  i := 0;
  if Length(EditOlapTol.Text) > 0 then
    i := StrToInt(EditOlapTol.Text);
  if Button = btNext then begin
    i := i + 1;
  end else begin
    i := i - 1;
  end;
  EditOlapTol.Text := inttostr(i);
end;

end.
