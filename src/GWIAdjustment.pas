unit GWIAdjustment;

interface


type
  TGWIAdjustment = class(TObject)
    constructor Create(d: integer; v: real);// overload;
  private
    FDate: integer;
    FValue: real;
  public
    property Date: integer
      read FDate write FDate;
    property Value: real
      read FValue write FValue;
  end;


implementation

constructor TGWIAdjustment.Create(d: integer; v: real);
begin
  Date := d;
  Value := v;
end;

end.

