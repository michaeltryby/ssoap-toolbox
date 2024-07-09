unit GWIAdjustmentsTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GWIAdjustment, GWIAdjustmentCollection, moddatabase, StdCtrls, Grids;

type
  TfrmGWIAdjustmentTable = class(TForm)
    AnalysisNameComboBox: TComboBox;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure AnalysisNameComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    gwiAdjustments: TGWIAdjustmentCollection;
    analysisID: integer;
    Procedure LoadGWIAdjustments;
  public
    { Public declarations }
  end;

var
  frmGWIAdjustmentTable: TfrmGWIAdjustmentTable;

implementation

{$R *.dfm}



{ TfrmGWIAdjustmentTable }

procedure TfrmGWIAdjustmentTable.AnalysisNameComboBoxChange(Sender: TObject);
begin
  //rm 2007-10-09 - analysisID := StrtoInt(Copy(AnalysisNameComboBox.Text,9,Length(AnalysisNameComboBox.Text)-8));
  //analysisID := StrtoInt(Copy(AnalysisNameComboBox.Text,Length(AnalysisNameComboBox.Text),1));
  analysisID := DatabaseModule.GetAnalysisIDForName(AnalysisNameComboBox.Text);
  LoadGWIAdjustments;
end;

procedure TfrmGWIAdjustmentTable.FormShow(Sender: TObject);
begin
//rm 2007-10-08 - a little error checking here:
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames();
  if (AnalysisNameComboBox.Items.Count > 0) then begin
    AnalysisNameComboBox.ItemIndex := 0;
    //rm 2007-10-09 - analysisID := StrtoInt(Copy(AnalysisNameComboBox.Text,9,Length(AnalysisNameComboBox.Text)-8));
    analysisID := DatabaseModule.GetAnalysisIDForName(AnalysisNameComboBox.Text);
    LoadGWIAdjustments;
  end else begin
    analysisID := -1;
  end;
end;

procedure TfrmGWIAdjustmentTable.LoadGWIAdjustments;
var i: integer;
  gwiAdjustment, earlierAdjustment, laterAdjustment: TGWIAdjustment;
begin
  StringGrid1.RowCount := 2;
  StringGrid1.Rows[1].Clear;
  StringGrid1.ColCount := 3;
  StringGrid1.Cells[1,0] := 'Adjustment Date';
  StringGrid1.Cells[2,0] := 'Adjustment Value';
  if analysisID > -1 then begin
    gwiAdjustments := DatabaseModule.GetGWIAdjustments(analysisID);
    for i := 1 to gwiAdjustments.Count do
    begin
      StringGrid1.RowCount := StringGrid1.Rowcount + 1;
      StringGrid1.FixedRows := 1;
      gwiAdjustment := gwiAdjustments.items[i-1];
      StringGrid1.Cells[1,i] := FormatDateTime('ddddd',gwiAdjustment.Date);
      StringGrid1.Cells[2,i] := FormatFloat('#.0000',gwiAdjustment.Value);
    end;
  end else begin

  end;
end;

end.
