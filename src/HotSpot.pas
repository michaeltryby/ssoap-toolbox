unit HotSpot;

interface
uses Forms, Classes, ComCtrls, StdCtrls, ExtCtrls, Graphics, Menus,
       Windows, ExtActns, Dialogs, SysUtils;
type
  THotSpot = class(TObject)
    constructor Create(_x1, _x2, _y1, _y2, _xmax, _ymax : integer;
      _menuitems:Array of TMenuItem; _popup: boolean; _caption: string; _hint:string; _color:TColor;
      _tag:integer; _shape:TShapeType; _frm:TForm); overload;
    destructor Destroy; overload;
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelMouseLeave(Sender: TObject);
    procedure LabelHotSpotClick(Sender: TObject);
    private
      x1: integer;
      x2: integer;
      y1: integer;
      y2: integer;
      xmax: integer;
      ymax: integer;
      menuitems: Array of TMenuItem;
      arat: double;
      frm: TForm;
      hotlabel: TLabel;
      hotshape: TShape;
      color0: TColor;
      color1: TColor;
      color2: TColor;
      FHint: string;
      FEnabled: boolean;
    procedure SetHint(const Value: string);
    function GetHint: string;
    function GetEnabled: boolean;
    procedure SetEnabled(const Value: boolean);
    public
      Left: integer;
      Top: integer;
      Width: integer;
      Height: integer;
      popup: boolean;
      caption: string;
      Font: TFont;
      tag: integer;
      //hotlabel: TLabel;
      //function IsHit(x,y,xm,ym: integer): boolean;
      property Hint: string read GetHint write SetHint;
      property Enabled: boolean read GetEnabled write SetEnabled;
      procedure RePosition(xm,ym:integer);

  end;


implementation
  uses mainForm;

constructor THotSpot.Create(_x1, _x2, _y1, _y2, _xmax, _ymax: integer;
  _menuitems:Array of TMenuItem; _popup:boolean; _caption:string; _hint:string; _color:TColor;
  _tag:integer; _shape: TShapeType; _frm:TForm);
var i,j: integer;
begin
  x1 := _x1;
  x2 := _x2;
  y1 := _y1;
  y2 := _y2;
  xmax := _xmax;
  ymax := _ymax;
  Left := -1;
  Top := -1;
  Width := -1;
  Height := -1;
  j := High(_menuitems);
  if j > -1 then begin
    SetLength(menuitems, j + 1);
    for i := 0 to j do begin
      menuitems[i] := _menuitems[i];
    end;
  end;
  popup := _popup;
  caption := _caption;
  FHint := _hint;
  color0 := _color or $EEEEEE;   //add light gray to get very light shade
  color1 := _color or $AAAAAA;   //add gray to get light shade
  color2 := _color;              //not lightened
  tag := _tag;
  frm := _frm;
  hotshape := TShape.Create(frm);
  hotshape.Parent := frm;
  hotshape.Shape := _shape;
  hotshape.Brush.Color := color0;
  hotshape.Visible := true;
  hotlabel := TLabel.Create(frm);
  with hotlabel do begin
    Parent := frm;
    hotlabel.Alignment := taCenter;
    AutoSize := False;
    Caption := _caption;
    Font.Color := clBlack;
    Font.Size := 8;
    Font.Name := 'Arial';
    Font.Style := [];
    ParentColor := False;
    ParentFont := False;
    Transparent := True;
    Layout := tlCenter;
    Hint := _hint;
    ShowHint := (length(Hint) > 0);
    Tag := _tag;
    Visible := True;
    WordWrap := True;
    OnMouseEnter := LabelMouseEnter;
    OnMouseLeave := LabelMouseLeave;
    OnClick := LabelHotSpotClick;
  end;
end;


destructor THotSpot.Destroy;
begin
  hotlabel.Free;
  hotshape.Free;
  inherited destroy;
end;
function THotSpot.GetEnabled: boolean;
begin
  Result := FEnabled;
end;

function THotSpot.GetHint: string;
begin
  Result := FHint;
end;

(*
function THotSpot.IsHit(x,y,xm,ym:integer): boolean;
var
  xrat, yrat, arat: double;
  x0, y0, xt, yt: integer;
begin
  xrat := ( xm / xmax );
  yrat := ( ym / ymax );
  x0 := 0;
  y0 := 0;
  if (xrat > yrat) then begin
    x0 := round((xm - (yrat * xmax)) / 2.0 );
    arat := yrat;
  end else begin
    y0 := round((ym - (xrat * ymax)) / 2.0 );
    arat := xrat;
  end;

  Left := round((x1 * arat) + x0);
  Top := round((y1 * arat) + y0);
  Width := round((x2 - x1) * arat);
  Height := round((y2 - y1) * arat);
{
  if (xt > Left) and (xt < Left + Width) and
      (yt > Top) and (yt < Top + Height) then
    result := true
  else
    result := false;
}

  xt := round((x - x0) / arat);
  yt := round((y - y0) / arat);
  if (xt > x1) and (xt < x2) and
      (yt > y1) and (yt < y2) then
    result := true
  else
    result := false;

  Font.Size := round(arat * 15);

end;
*)

procedure THotSpot.RePosition(xm, ym: integer);
var
  xrat, yrat: double;
  x0, y0, xt, yt: integer;
begin
if ((xmax <1) or (ymax < 1)) then exit;

  xrat := ( xm / xmax );
  yrat := ( ym / ymax );
  x0 := 0;
  y0 := 0;
  if (xrat > yrat) then begin
    x0 := round((xm - (yrat * xmax)) / 2.0 );
    arat := yrat;
  end else begin
    y0 := round((ym - (xrat * ymax)) / 2.0 );
    arat := xrat;
  end;
  hotlabel.Left := round((x1 * arat) + x0);
  hotlabel.Top := round((y1 * arat) + y0);
  hotlabel.Width := round((x2 - x1) * arat);
  hotlabel.Height := round((y2 - y1) * arat);
  hotlabel.Font.Size := round(arat * 11);
  hotshape.Left := hotlabel.Left - 2;
  hotshape.Top := hotlabel.Top - 2;
  hotshape.Width := hotlabel.Width + 4;
  hotshape.Height := hotlabel.Height + 4;
end;

procedure THotSpot.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
  if FEnabled then
    hotshape.Brush.Color := color1
  else
    hotshape.Brush.Color := color0;
end;

procedure THotSpot.SetHint(const Value: string);
begin
  FHint := Value;
  hotlabel.Hint := FHint;
  hotlabel.ShowHint := (Length(FHint) > 0);
end;

procedure THotSpot.LabelMouseEnter(Sender: TObject);
begin
  if popup then begin
    //LockWindowUpdate(frm.Handle);
    hotlabel.Font.Size := round(arat * 15);
    if Enabled then
      hotshape.Brush.Color := color2
    else
      hotshape.Brush.Color := color1;
    //Application.ProcessMessages;
    //LockWindowUpdate(0);
  end;
end;

procedure THotSpot.LabelMouseLeave(Sender: TObject);
begin
  if popup then begin
    //LockWindowUpdate(frm.Handle);
    //rm 2007-10-15 - lockwindowupdate is not
    //preventing the shapes from flickering.
    //used doublebuffering instead
    hotlabel.Font.Size := round(arat * 11);
    if Enabled then
      hotshape.Brush.Color := color1
    else
      hotshape.Brush.Color := color0;
    //Application.ProcessMessages;
    //LockWindowUpdate(0);
  end;
end;

procedure THotSpot.LabelHotSpotClick(Sender: TObject);
var myFileRunner: TFileRun;
    myPoint: TPoint;
begin
  with sender as TLabel do begin
    frmMain.SetupMenuItemsforIndex(menuitems);
//rm 2007-10-19 - revised placement of popup menu -
//    frmMain.PopupMenuHotSpot.Popup(
//      Left + frmMain.ClientRect.Left + frmMain.Image1.Left + frmMain.Left + Width div 2 ,
//      Top + frmMain.ClientRect.Top + frmMain.Image1.Top + frmMain.Top + Height div 2);
    myPoint.X := Left + Width div 2;
    myPoint.Y := Top - frmMain.Canvas.TextHeight('Wy');
    frmMain.PopupMenuHotSpot.Popup( frmMain.ClientToScreen(myPoint).X,
                                    frmMain.ClientToScreen(myPoint).Y );
//rm
  end;
end;

end.
