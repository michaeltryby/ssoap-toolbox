unit MenuItemForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TfrmMenuItem = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    Label2: TLabel;
    Memo2: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    spaces: string;
    function fix(aCaption: string): string;
    function fix2(aCaption: string;num: integer): string;
    procedure AddMenuChildren(Parent, Child: TMenuItem);
    procedure TraverseMenuChildren(Child: TMenuItem);
  public
    { Public declarations }
  end;

var
  frmMenuItem: TfrmMenuItem;

implementation

uses mainform;

{$R *.dfm}

procedure TfrmMenuItem.TraverseMenuChildren(Child: TMenuItem);
var i: integer;
  aMenuItem:TMenuItem;
begin
  spaces := spaces + '        ';
  Memo1.Lines.Add(spaces +  fix(Child.Caption));
  for i := 0 to Child.Count - 1 do begin
    if Child.Items[i].Visible then begin
      TraverseMenuChildren(Child.Items[i]);
      spaces := Copy(spaces,1, Length(spaces)-8);
    end;
  end;
end;

procedure TfrmMenuItem.AddMenuChildren(Parent, Child: TMenuItem);
var i: integer;
  aMenuItem:TMenuItem;
begin
  aMenuItem := TMenuItem.Create(MainMenu1);
  aMenuItem.Caption := Child.Caption;
  aMenuItem.OnClick := MenuItemClick;
  Parent.Add(aMenuItem);
  for i := 0 to Child.Count - 1 do begin
    if Child.Items[i].Visible then
      AddMenuChildren(aMenuItem,Child.Items[i]);
  end;
end;

procedure TfrmMenuItem.btnCancelClick(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Clear;
  close;
end;

procedure TfrmMenuItem.btnOKClick(Sender: TObject);
begin
  close;
end;


procedure TfrmMenuItem.Button1Click(Sender: TObject);
var i, j, icount: integer;
  sourceMenuItem:TMenuItem;
begin
  for i := 0 to frmMain.Menu.Items.Count - 1 do begin
    sourceMenuItem := frmMain.Menu.Items[i];
    spaces := '';
    //Memo1.Lines.Add(fix(sourceMenuItem.Caption));
    if sourceMenuItem.Visible then begin
      Memo1.Lines.Add(fix(sourceMenuItem.Caption));
      //traverse children
      for j := 0 to sourceMenuItem.Count - 1 do begin
        if sourceMenuItem.Items[j].visible then begin
          TraverseMenuChildren(sourceMenuItem.Items[j]);
          spaces := Copy(spaces,1, Length(spaces)-8);
        end;
      end;
    end;
  end;
end;

function TfrmMenuItem.fix(aCaption: string): string;
begin
//remove the ampersand that represents the underscore/shortcut
  Result := StringReplace(aCaption,'&','',[rfReplaceAll]);
end;

function TfrmMenuItem.fix2(aCaption: string; num: integer): string;
var i: integer;
    s: string;
begin
//add num tabs to beginning
  s := '';
  for i := 0 to num - 1 do
    s := s + #9;
  Result := s + aCaption;
end;

procedure TfrmMenuItem.FormCreate(Sender: TObject);
var i, j, icount: integer;
  newMenuItem,sourceMenuItem:TMenuItem;
begin
  for i := 0 to frmMain.Menu.Items.Count - 1 do begin
    sourceMenuItem := frmMain.Menu.Items[i];
    if sourceMenuItem.Visible then begin
      newMenuItem := TMenuItem.Create(MainMenu1);
      newMenuItem.Caption := sourceMenuItem.Caption;
      newMenuItem.OnClick := MenuItemClick;
      MainMenu1.Items.Add(newMenuItem);
      //add children
      for j := 0 to sourceMenuItem.Count - 1 do begin
        if sourceMenuItem.Items[j].visible then
          AddMenuChildren(newMenuItem,sourceMenuItem.Items[j]);
      end;
    end;
  end;
end;

procedure TfrmMenuItem.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
key := #0;
end;

procedure TfrmMenuItem.MenuItemClick(Sender: TObject);
var i,j: integer;
  aMenuItem:TMenuItem;
  aStringList: TStringList;
begin
  Memo1.Clear;
  aStringList := TStringList.Create;
  aMenuItem := Sender as TMenuItem;
  aStringList.Add(aMenuItem.MethodName(nil) );
  while aMenuItem.Parent is TMenuItem do begin
    aStringList.Add(fix(aMenuItem.Caption));
    aMenuItem := aMenuItem.Parent;
  end;
  j := 0;
  for i := aStringList.Count - 1 downto 0 do begin
    Memo1.Lines.Add(fix2(aStringList[i],j));
    inc(j);
  end;
  aStringList.Free;
end;

end.
