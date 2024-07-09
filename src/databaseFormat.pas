unit databaseFormat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmDatabaseFormat = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    access97RadioButton: TRadioButton;
    access2000RadioButton: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDatabaseFormat: TfrmDatabaseFormat;

implementation

{$R *.DFM}

end.
